// ignore_for_file: deprecated_member_use

import 'package:auth_screens/Controllers/Authentication/auth_services.dart';
import 'package:auth_screens/View/ChatBot/chatbot_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      endDrawer: Drawer(
        backgroundColor: Colors.grey.shade100,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.yellow.shade700),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Shop Ease",
                    style: TextStyle(
                      color: Colors.black,
                      letterSpacing: 2,
                      fontSize: height * 0.03,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.lobsterTwo().fontFamily,
                    ),
                  ),
                  Text(
                    "One stop shop for all needs",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: height * 0.018,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                    ),
                  ),
                ],
              ),
            ),
            // Add drawer items here
          ],
        ),
      ),

      //  APP BAR
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        iconTheme: IconThemeData(color: Colors.yellow.shade800),

        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.yellow.shade800.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.shopping_bag, color: Colors.yellow.shade800),
            ),
            SizedBox(width: 10),
            Text(
              "Shop Ease",
              style: TextStyle(
                fontFamily: GoogleFonts.lobsterTwo().fontFamily,
                color: Colors.yellow.shade800,
                fontWeight: FontWeight.bold,
                letterSpacing: .5,
              ),
            ),
          ],
        ),
      ),

      //  BODY
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.02,
          vertical: height * 0.02,
        ),
        child: ListView(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: "Search for products",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
          ],
        ),
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
