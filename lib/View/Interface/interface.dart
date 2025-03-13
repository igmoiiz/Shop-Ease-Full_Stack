// ignore_for_file: deprecated_member_use

import 'package:auth_screens/Controllers/Authentication/auth_services.dart';
import 'package:auth_screens/Controllers/Interface/interface_controller.dart';
import 'package:auth_screens/View/ChatBot/chatbot_page.dart';
import 'package:auth_screens/View/Components/category_tile.dart';
import 'package:auth_screens/View/Components/large_category_tile.dart';
import 'package:carousel_slider/carousel_slider.dart';
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
  //  Instance for Interface Controller
  final InterfaceController interfaceController = InterfaceController();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      endDrawer: Drawer(
        backgroundColor: Colors.grey.shade100,
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: DrawerHeader(
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
            ),
            Spacer(),
            Divider(),
            // Add drawer items here
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 10,
              ),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.logout_rounded,
                    color: Colors.orange.shade800,
                    size: 26,
                  ),
                ),
                title: const Text(
                  "Sign Out",
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                subtitle: const Text(
                  "Good Bye!",
                  style: TextStyle(color: Colors.black54, fontSize: 12),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey.shade400,
                  size: 16,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                tileColor: Colors.white,
                onTap: () {
                  authServices.signOutAndEndSession(context);
                },
              ),
            ),
          ],
        ),
      ),

      //  APP BAR
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        iconTheme: IconThemeData(color: Colors.yellow.shade800),
        automaticallyImplyLeading: false,
        elevation: 0.0,
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
          horizontal: width * 0.025,
          vertical: height * 0.02,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //  Carousel View
            CarouselSlider(
              items:
                  interfaceController.carouselItems
                      .map(
                        (items) => Container(
                          margin: EdgeInsets.all(5.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                            child: Image.asset(
                              items,
                              fit: BoxFit.cover,
                              width: 1000.0,
                            ),
                          ),
                        ),
                      )
                      .toList(),
              options: CarouselOptions(
                height: 180.0,
                enlargeCenterPage: true,
                autoPlay: true,
                aspectRatio: 16 / 9,
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                viewportFraction: 0.9,
              ),
            ),
            SizedBox(height: height * 0.02),
            //  Featured Categories Heading
            Text(
              "New Arrivals",
              style: TextStyle(
                color: Colors.black.withOpacity(0.65),
                fontWeight: FontWeight.bold,
                letterSpacing: .5,
                fontSize: height * 0.03,
                fontFamily: GoogleFonts.outfit().fontFamily,
              ),
            ),
            SizedBox(height: height * 0.015),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CategoryTile(
                  icon: Icons.electrical_services,
                  text: "Electric Accesssories",
                  onPressed: () {},
                ),
                CategoryTile(
                  icon: Icons.brush,
                  text: "Cosmetics",
                  onPressed: () {},
                ),
                CategoryTile(
                  icon: Icons.house,
                  text: "Household Products",
                  onPressed: () {},
                ),
              ],
            ),
            SizedBox(height: height * 0.02),
            Text(
              "Featured Categories",
              style: TextStyle(
                color: Colors.black.withOpacity(0.65),
                fontWeight: FontWeight.bold,
                letterSpacing: .5,
                fontSize: height * 0.03,
                fontFamily: GoogleFonts.outfit().fontFamily,
              ),
            ),

            //  Grid View for Categories
            Expanded(
              child: GridView.builder(
                itemCount: interfaceController.largeCategoryItems.length,
                scrollDirection: Axis.vertical,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.all(5.0),
                    child: LargeCategoryTile(
                      backgroundImage:
                          interfaceController.largeCategoryItems[index],
                      onTap: () {},
                      title: interfaceController.largeCategoryTitles[index],
                    ),
                  );
                },
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
