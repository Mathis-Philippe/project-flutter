import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import { config } from "https://deno.land/std@0.168.0/dotenv/mod.ts";

config({ path: '.env' });

const PROMPT_STYLES: Record<string, string> = {
  brainrot: "Transforme ce message pour qu'il ait l'air d'être écrit par une personne qui parle en Brainrot.",
  soutenu: "Transforme ce message dans un langage très soutenu, formel et poétique (parle comme Cyrano de Bergerac en vers).",
  debile: "Transforme ce message pour qu'il soit écrit par une personne avec 40 de QI.",
};

serve(async (req) => {
  try {
    const { sender_id, receiver_id, original_message, style } = await req.json()

    const instruction = PROMPT_STYLES[style] || "Corrige simplement les fautes d'orthographe de ce message sans en changer le sens.";

    const prompt = `${instruction} Voici le message : "${original_message}". Ne renvoie QUE le message modifié, sans aucun autre commentaire.`;

    const geminiApiKey = Deno.env.get('GEMINI_API_KEY') ?? '';

    const geminiResponse = await fetch(`https://generativelanguage.googleapis.com/v1beta/models/gemini-3.5-flash:generateContent?key=${geminiApiKey}`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        contents: [{ parts: [{ text: prompt }] }]
      })
    })

    const geminiData = await geminiResponse.json()
    
    if (!geminiData.candidates || !geminiData.candidates[0]) {
      throw new Error(`Erreur Gemini API: ${JSON.stringify(geminiData)} | Clé utilisée: ${geminiApiKey.substring(0, 5)}...`);
    }

    const alteredMessage = geminiData.candidates[0].content.parts[0].text

    const supabaseClient = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_ANON_KEY') ?? '',
      {
        global: {
          headers: { Authorization: req.headers.get('Authorization')! },
        },
      }
    )

    const { error } = await supabaseClient
      .from('messages')
      .insert([
        { sender_id, receiver_id, text: alteredMessage }
      ])

    if (error) throw error

    return new Response(JSON.stringify({ success: true }), {
      headers: { "Content-Type": "application/json" },
      status: 200,
    })

  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), {
      headers: { "Content-Type": "application/json" },
      status: 400,
    })
  }
})