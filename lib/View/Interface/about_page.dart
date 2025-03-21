// ignore_for_file: deprecated_member_use, depend_on_referenced_packages

import 'package:auth_screens/Controllers/Interface/interface_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  AboutPage({super.key});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  //  Instance for Interface Controller
  final InterfaceController interfaceController = InterfaceController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        iconTheme: IconThemeData(color: Colors.yellow.shade800),
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
              "About Us",
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
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App logo and name
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          Icons.shopping_bag,
                          size: 70,
                          color: Colors.yellow.shade800,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "ShopEase",
                      style: TextStyle(
                        fontFamily: GoogleFonts.lobsterTwo().fontFamily,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.yellow.shade800,
                      ),
                    ),
                    Text(
                      "Making online shopping a breeze",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade700,
                        fontFamily: GoogleFonts.outfit().fontFamily,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.yellow.shade800,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "v1.2.0",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // App description
              _buildSectionTitle(context, "About ShopEase"),
              _buildCard(
                context,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    interfaceController.aboutApplicaiton,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.grey.shade800,
                      fontFamily: GoogleFonts.outfit().fontFamily,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Features
              _buildSectionTitle(context, "Key Features"),
              _buildCard(
                context,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildFeatureItem(
                        icon: Icons.person,
                        title: "User Authentication",
                        description:
                            "Secure login, registration and profile management",
                      ),
                      _buildDivider(),
                      _buildFeatureItem(
                        icon: Icons.shopping_bag,
                        title: "Product Discovery",
                        description:
                            "Browse products by categories with comprehensive search",
                      ),
                      _buildDivider(),
                      _buildFeatureItem(
                        icon: Icons.shopping_cart,
                        title: "Shopping Cart",
                        description:
                            "Add, remove products and update quantities",
                      ),
                      _buildDivider(),
                      _buildFeatureItem(
                        icon: Icons.payment,
                        title: "Checkout Process",
                        description:
                            "Multiple payment methods and shipping options",
                      ),
                      _buildDivider(),
                      _buildFeatureItem(
                        icon: Icons.psychology,
                        title: "AI Chatbot Assistant",
                        description:
                            "Smart AI-powered support with conversation history",
                      ),
                      _buildDivider(),
                      _buildFeatureItem(
                        icon: Icons.auto_awesome,
                        title: "User Experience",
                        description: "Smooth animations and responsive design",
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Technologies
              _buildSectionTitle(context, "Technologies Used"),
              _buildCard(
                context,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildTechItem(
                              icon: Icons.flutter_dash,
                              title: "Flutter",
                            ),
                          ),
                          Expanded(
                            child: _buildTechItem(
                              icon: Icons.data_object,
                              title: "Dart",
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTechItem(
                              icon: Icons.fireplace,
                              title: "Firebase",
                            ),
                          ),
                          Expanded(
                            child: _buildTechItem(
                              icon: Icons.storage,
                              title: "Firestore",
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTechItem(
                              icon: Icons.lock,
                              title: "Authentication",
                            ),
                          ),
                          Expanded(
                            child: _buildTechItem(
                              icon: Icons.api,
                              title: "REST APIs",
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTechItem(
                              icon: Icons.storage_rounded,
                              title: "Supabase",
                            ),
                          ),
                          Expanded(
                            child: _buildTechItem(
                              icon: Icons.public,
                              title: "GitHub",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Developer
              _buildSectionTitle(context, "Developers"),
              _buildCard(
                context,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.yellow.shade800.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                "MB",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.yellow.shade800,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Moiz Baloch",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: GoogleFonts.outfit().fontFamily,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Flutter Developer",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      _buildDivider(),
                      Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.yellow.shade800.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                "AB",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.yellow.shade800,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Aima Bilal",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: GoogleFonts.outfit().fontFamily,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Flutter Developer",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),
              _buildSectionTitle(context, "Contact Us"),
              // Contact
              _buildCard(
                context,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildContactItem(
                        icon: Icons.email,
                        title: "Email",
                        value: "khanmoaiz682@gmail.com",
                        onTap:
                            () => _launchUrl("mailto:khanmoaiz682@gmail.com"),
                      ),
                      _buildDivider(),
                      _buildContactItem(
                        icon: Icons.public,
                        title: "GitHub",
                        value: "github.com/igmoiiz",
                        onTap:
                            () => _launchUrl(
                              "https://github.com/igmoiiz/Shop-Ease-Full_Stack",
                            ),
                      ),
                      _buildDivider(),
                      _buildContactItem(
                        icon: Icons.camera_alt,
                        title: "Instagram",
                        value: "@ig_moiiz",
                        onTap:
                            () => _launchUrl(
                              "https://www.instagram.com/ig_moiiz/",
                            ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Copyright
              Center(
                child: Text(
                  "© 2025 ShopEase. All rights reserved.",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontFamily: GoogleFonts.outfit().fontFamily,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Center(
                child: Text(
                  "Made with ❤️ by Moiz Baloch",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontFamily: GoogleFonts.outfit().fontFamily,
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.yellow.shade900,
          fontFamily: GoogleFonts.outfit().fontFamily,
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, {required Widget child}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.yellow.shade800.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.yellow.shade800, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechItem({required IconData icon, required String title}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.yellow.shade800, size: 28),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.yellow.shade800),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey.shade400,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(color: Colors.grey.shade200, height: 24);
  }
}
