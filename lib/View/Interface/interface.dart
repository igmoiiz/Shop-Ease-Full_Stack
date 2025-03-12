import 'package:auth_screens/Controllers/Authentication/auth_services.dart';
import 'package:auth_screens/View/ChatBot/chatbot_page.dart';
import 'package:flutter/material.dart';

class InterfacePage extends StatefulWidget {
  const InterfacePage({super.key});

  @override
  State<InterfacePage> createState() => _InterfacePageState();
}

class _InterfacePageState extends State<InterfacePage> {
  //  Instance for Auth Services
  final AuthServices authServices = AuthServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow.shade700,
        automaticallyImplyLeading: false,
        title: Text("Interface Page"),
        actions: [
          IconButton(
            onPressed: () {
              authServices.signOutAndEndSession(context);
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),

      //  Floating Action Button
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.yellow.shade700,
        onPressed: () {
          Navigator.of(context).push(_elegantRoute(ChatbotPage()));
        },
        child: Icon(Icons.chat_rounded, color: Colors.white),
      ),
    );
  }

  PageRouteBuilder _elegantRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var fadeAnimation = Tween<double>(begin: 0, end: 1).animate(animation);
        var scaleAnimation = Tween<double>(begin: 0.95, end: 1).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutExpo),
        );
        return FadeTransition(
          opacity: fadeAnimation,
          child: ScaleTransition(scale: scaleAnimation, child: child),
        );
      },
      transitionDuration: const Duration(milliseconds: 500),
    );
  }
}
