import 'dart:developer';

import 'package:auth_screens/Controllers/API%20Services/Chatbot/chat_bot_controller.dart';
import 'package:auth_screens/Controllers/API%20Services/Thrift%20Store/api_services.dart';
import 'package:auth_screens/Controllers/Interface/interface_controller.dart';
import 'package:auth_screens/View/Auth%20Gate/auth_gate.dart';
import 'package:auth_screens/Utils/consts.dart';
import 'package:auth_screens/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:auth_screens/Controllers/Cart%20Services/cart_services.dart';

Future<void> main() async {
  //  Initialize the Widget Binding
  WidgetsFlutterBinding.ensureInitialized();
  //  Firebase Setup
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((value) {
        log("Firebase Setup Completed. Initializing Supabase");
        //  Supabase Setup
        Supabase.initialize(url: url, anonKey: anonKey)
            .then((value) {
              log("Supabase initialization completed. Running the application");
              //  Run the application
              runApp(
                MultiProvider(
                  providers: [
                    ChangeNotifierProvider(
                      create: (context) => ChatbotController(),
                    ),
                    ChangeNotifierProvider(
                      create: (context) => InterfaceController(),
                    ),
                    ChangeNotifierProvider(create: (context) => ApiServices()),
                    ChangeNotifierProvider(create: (context) => CartServices()),
                  ],
                  child: const MyApp(),
                ),
              );
            })
            .onError((error, stackTrace) {
              log("Supabase initialization failed; $error");
            });
      })
      .onError((error, stackTrace) {
        log("Firebase initialization failed; $error");
      });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShopEase',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
        scaffoldBackgroundColor: Colors.grey.shade100,
      ),
      home: const AuthGate(),
    );
  }
}
