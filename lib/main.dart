import 'dart:developer';

import 'package:auth_screens/Controllers/Chatbot/chat_bot_controller.dart';
import 'package:auth_screens/View/Auth_Gate/auth_gate.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  //  VARIABLES FOR SUPABASE INITIALIZATION
  const url = "https://vfazqatlbiewmmsbiboh.supabase.co";
  const anonKey =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZmYXpxYXRsYmlld21tc2JpYm9oIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDE3MDU3NzEsImV4cCI6MjA1NzI4MTc3MX0.dc8TlRM38luvir8W4d7F0bN2DcmzmBzEvpOxsf-yFUE";
  //  INITIALIZE THE WIDGET BINDING
  WidgetsFlutterBinding.ensureInitialized();
  //  SUPABASE INITIALIZATION
  await Supabase.initialize(url: url, anonKey: anonKey)
      .then((value) {
        log("Supabase Initialization Completed");
        runApp(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => ChatbotController()),
            ],
            child: const MainApp(),
          ),
        );
      })
      .onError((error, stackTrace) {
        log("Supabase Initialization Failed!");
      });
  //  RUN THE APPLICATION
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: GoogleFonts.poppins().fontFamily,
        useMaterial3: true,
      ),
      home: const AuthGate(),
    );
  }
}
