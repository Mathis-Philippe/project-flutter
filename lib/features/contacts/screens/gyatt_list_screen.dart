import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../chat/models/message_model.dart';

class GyattListScreen extends StatefulWidget {
  const GyattListScreen({super.key});

  @override
  State<GyattListScreen> createState() => _GyattListScreenState();
}

class _GyattListScreenState extends State<GyattListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  List<Contact> _myContacts = [];
  List<Contact> _suggestions = [];
  List<Contact> _filteredContacts = [];
  List<Contact> _filteredSuggestions = [];
  bool _isLoading = true;

  List<Color> get _gradientColors => _tabController.index == 0
      ? [const Color(0xFF8A46FF), const Color(0xFF00BCD4)]
      : [const Color(0xFF4CAF50), const Color(0xFF00BCD4)];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() => setState(() {}));
    _searchController.addListener(_filterLists);
    _loadData();
  }

  void _filterLists() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredContacts = _myContacts.where((c) => c.name.toLowerCase().contains(query)).toList();
      _filteredSuggestions = _suggestions.where((c) => c.name.toLowerCase().contains(query)).toList();
    });
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final supabase = Supabase.instance.client;
      final userId = supabase.auth.currentUser!.id;
      
      final profilesRes = await supabase.from('profiles').select();
      final allProfiles = profilesRes as List;
      
      final fRes = await supabase.from('friends').select('friend_id').eq('user_id', userId);
      final friendIds = (fRes as List).map((e) => e['friend_id'] as String).toSet();
      
      final List<Contact> contacts = [];
      final List<Contact> suggests = [];
      
      for (var p in allProfiles) {
        if (p['id'] == userId) continue;
        
        final contact = Contact(
          id: p['id'],
          name: p['username'] ?? 'Utilisateur',
          avatarUrl: p['avatar_url'] ?? 'https://i.pravatar.cc/150?u=${p['id']}',
          isContact: friendIds.contains(p['id']),
        );
        
        if (contact.isContact) {
          contacts.add(contact);
        } else {
          suggests.add(contact);
        }
      }
      
      if (mounted) {
        setState(() {
          _myContacts = contacts;
          _suggestions = suggests;
          _isLoading = false;
        });
        _filterLists();
      }
    } catch (e) {
      debugPrint("Erreur lors du chargement des amis: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _addFriend(String friendId) async {
    try {
      final userId = Supabase.instance.client.auth.currentUser!.id;
      await Supabase.instance.client.from('friends').insert({
        'user_id': userId,
        'friend_id': friendId,
      });
      _loadData();
    } catch (e) {
      debugPrint("Erreur ajout ami: $e");
    }
  }
  
  Future<void> _removeFriend(String friendId) async {
    try {
      final userId = Supabase.instance.client.auth.currentUser!.id;
      await Supabase.instance.client.from('friends').delete().match({
        'user_id': userId,
        'friend_id': friendId,
      });
      _loadData();
    } catch (e) {
      debugPrint("Erreur suppression ami: $e");
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // Header dégradé
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  // Titre + retour
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 8, 16, 12),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Text(
                          'GYATT LIST',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Barre de recherche
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white.withOpacity(0.5), width: 1),
                      ),
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(color: Colors.white, fontSize: 15),
                        decoration: InputDecoration(
                          hintText: "Rechercher un contact...",
                          hintStyle: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 15),
                          prefixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.8)),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(8),
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F0F0),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(26),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey[600],
                labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Suggestions"),
                        const SizedBox(width: 6),
                        _badge(_filteredSuggestions.length, const Color(0xFF00BCD4)),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Mes contacts"),
                        const SizedBox(width: 6),
                        _badge(_filteredContacts.length, const Color(0xFF4CAF50)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Contenu des onglets
          Expanded(
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator())
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildSuggestionsList(),
                    _buildContactsList(),
                  ],
                ),
          ),
        ],
      ),
    );
  }

  Widget _badge(int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
      child: Text(
        '$count',
        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSuggestionsList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _filteredSuggestions.length,
      itemBuilder: (context, index) {
        final contact = _filteredSuggestions[index];
        return _buildSuggestionTile(contact);
      },
    );
  }

  Widget _buildSuggestionTile(Contact contact) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 1),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          // Avatar avec ring vert
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4CAF50), Color(0xFF00BCD4)],
              ),
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: 28,
              backgroundImage: contact.avatarUrl.startsWith('assets/') 
                  ? AssetImage(contact.avatarUrl) as ImageProvider 
                  : NetworkImage(contact.avatarUrl),
              backgroundColor: Colors.grey[200],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact.name,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black87),
                ),
              ],
            ),
          ),
          // Bouton Ajouter
          ElevatedButton.icon(
            onPressed: () => _addFriend(contact.id),
            icon: const Icon(Icons.person_add_rounded, size: 16),
            label: const Text("Ajouter", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactsList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _filteredContacts.length,
      itemBuilder: (context, index) {
        final contact = _filteredContacts[index];
        return _buildContactTile(contact);
      },
    );
  }

  Widget _buildContactTile(Contact contact) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 1),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          // Avatar avec ring violet→cyan
          Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF8A46FF), Color(0xFF00BCD4)],
              ),
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: 28,
              backgroundImage: contact.avatarUrl.startsWith('assets/') 
                  ? AssetImage(contact.avatarUrl) as ImageProvider 
                  : NetworkImage(contact.avatarUrl),
              backgroundColor: Colors.grey[200],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact.name,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black87),
                ),
              ],
            ),
          ),
          // Bouton Supprimer (X rouge)
          GestureDetector(
            onTap: () => _removeFriend(contact.id),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.red[50],
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.close_rounded, color: Colors.red[400], size: 20),
            ),
          ),
        ],
      ),
    );
  }
}