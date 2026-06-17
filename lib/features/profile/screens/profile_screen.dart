import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = "Chargement...";
  String _avatarUrl = "https://i.pravatar.cc/150?img=33";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final supabase = Supabase.instance.client;
      final userId = supabase.auth.currentUser!.id;
      final res = await supabase.from('profiles').select().eq('id', userId).single();
      
      if (mounted) {
        setState(() {
          _name = res['username'] ?? "Utilisateur";
          _avatarUrl = res['avatar_url'] ?? "https://i.pravatar.cc/150?u=$userId";
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Erreur profil: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _editPseudo() async {
    final controller = TextEditingController(text: _name == "Chargement..." ? "" : _name);
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Modifier le pseudo"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: "Nouveau pseudo"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Annuler"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text.trim()),
              child: const Text("Enregistrer"),
            ),
          ],
        );
      },
    );

    if (result != null && result.isNotEmpty && result != _name) {
      final supabase = Supabase.instance.client;
      try {
        // Vérification unicité
        final existing = await supabase.from('profiles').select('id').eq('username', result);
        if ((existing as List).isNotEmpty) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Ce pseudo est déjà pris !"), backgroundColor: Colors.red),
            );
          }
          return;
        }

        // Mise à jour (ou création si ça n'existe pas)
        final userId = supabase.auth.currentUser!.id;
        await supabase.from('profiles').upsert({'id': userId, 'username': result});
        
        if (mounted) {
          setState(() {
            _name = result;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Pseudo mis à jour !"), backgroundColor: Colors.green),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Erreur: $e"), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header avec dégradé
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF8A46FF), Color(0xFF00BCD4)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(4, 8, 16, 20),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.maybePop(context),
                    ),
                    const Text(
                      'Profil',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  // Avatar centré avec ring dégradé et icône caméra
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF00BCD4), Color(0xFF8A46FF)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: 58,
                          backgroundImage: _avatarUrl.startsWith('assets/')
                              ? AssetImage(_avatarUrl) as ImageProvider
                              : NetworkImage(_avatarUrl),
                          backgroundColor: Colors.white,
                        ),
                      ),
                      Positioned(
                        right: 4,
                        bottom: 4,
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF00BCD4), Color(0xFF8A46FF)],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 18),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Nom en vert
                  _isLoading 
                    ? const CircularProgressIndicator()
                    : Text(
                        _name,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4CAF50),
                        ),
                      ),
                  const SizedBox(height: 4),
                  Text(
                    "Gooning",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[500],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Bouton Modifier le profil
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF8A46FF), Color(0xFF00BCD4)],
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: ElevatedButton(
                          onPressed: _editPseudo,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                          child: const Text(
                            "Modifier le profil",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Déconnexion
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey[200]!, width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.logout_rounded, color: Colors.red),
                        title: const Text(
                          "Déconnexion",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        onTap: () async {
                          await Supabase.instance.client.auth.signOut();
                        },
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}