// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:auth_screens/Controllers/Authentication/auth_services.dart';
import 'package:auth_screens/Controllers/Interface/interface_controller.dart';
import 'package:auth_screens/View/Cart/cart_page.dart';
import 'package:auth_screens/View/ChatBot/chatbot_page.dart';
import 'package:auth_screens/View/Components/cart_icon.dart';
import 'package:auth_screens/View/Components/category_tile.dart';
import 'package:auth_screens/View/Components/drawer_component.dart';
import 'package:auth_screens/View/Components/large_category_tile.dart';
import 'package:auth_screens/View/Interface/Featured%20Categories/featured_products.dart';
import 'package:auth_screens/View/Interface/about_page.dart';
import 'package:auth_screens/View/Interface/product_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class InterfacePage extends StatefulWidget {
  const InterfacePage({super.key});

  @override
  State<InterfacePage> createState() => _InterfacePageState();
}

class _InterfacePageState extends State<InterfacePage> {
  //  Instance for Auth Services
  final AuthServices authServices = AuthServices();

  // Use lazy loading for better performance
  late final InterfaceController interfaceController;

  @override
  void initState() {
    super.initState();
    // Initialize controller in initState
    interfaceController = Provider.of<InterfaceController>(
      context,
      listen: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      drawer: _buildDrawer(size),
      appBar: _buildAppBar() as PreferredSizeWidget,
      body: _buildBody(size),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildDrawer(Size size) {
    return Drawer(
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
                      fontSize: size.height * 0.03,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.lobsterTwo().fontFamily,
                    ),
                  ),
                  Text(
                    "One stop shop for all needs",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.height * 0.018,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                    ),
                  ),
                ],
              ),
            ),
          ),
          DrawerComponent(
            title: "View your Cart",
            icon: Icons.shopping_cart_rounded,
            onTap:
                () => Navigator.of(
                  context,
                ).push(_elegantRoute(CartPage())).then((value) {
                  Navigator.of(context).pop();
                }),
            subtitle: "See what's in your wishlist",
          ),
          DrawerComponent(
            title: "About Us",
            icon: Icons.info_outline,
            onTap:
                () => Navigator.of(
                  context,
                ).push(_elegantRoute(AboutPage())).then((value) {
                  Navigator.of(context).pop();
                }),
            subtitle: "Know more about us",
          ),
          const Spacer(),
          const Divider(),
          // Add drawer items here
          DrawerComponent(
            title: "Sign Out",
            icon: Icons.logout_rounded,
            onTap:
                () => authServices
                    .signOutAndEndSession(context)
                    .then((value) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.green.shade700,
                          content: Text(
                            "Hope to see you soon!",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: .5,
                              fontFamily: GoogleFonts.urbanist().fontFamily,
                            ),
                          ),
                        ),
                      );
                    })
                    .onError((error, stackTrace) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.red.shade700,
                          content: Text(
                            "Error Occurred: $error",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: .5,
                              fontFamily: GoogleFonts.urbanist().fontFamily,
                            ),
                          ),
                        ),
                      );
                    }),
            subtitle: "See you Soon!",
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.grey.shade100,
      iconTheme: IconThemeData(color: Colors.yellow.shade800),
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
      actions: [CartIcon()],
    );
  }

  Widget _buildBody(Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.025,
        vertical: size.height * 0.02,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CarouselSlider(
            items:
                interfaceController.carouselItems
                    .map(
                      (items) => Container(
                        margin: EdgeInsets.all(5.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
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
          SizedBox(height: size.height * 0.02),
          Text(
            "New Arrivals",
            style: TextStyle(
              color: Colors.yellow.shade900,
              fontWeight: FontWeight.bold,
              letterSpacing: .5,
              fontSize: size.height * 0.03,
              fontFamily: GoogleFonts.outfit().fontFamily,
            ),
          ),
          SizedBox(height: size.height * 0.015),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CategoryTile(
                icon: Icons.electrical_services,
                text: "Electronics",
                onPressed:
                    () => Navigator.of(context).push(
                      _elegantRoute(FeaturedProducts(category: "Electronics")),
                    ),
              ),

              CategoryTile(
                icon: Icons.house,
                text: "Household Products",
                onPressed:
                    () => Navigator.of(context).push(
                      _elegantRoute(FeaturedProducts(category: "Household")),
                    ),
              ),
              CategoryTile(
                icon: Icons.shopping_bag_outlined,
                text: "Thrift Store",
                onPressed: () {
                  Navigator.of(
                    context,
                  ).push(_elegantRoute(ProductPage(title: "Thrift Store")));
                },
              ),
            ],
          ),
          SizedBox(height: size.height * 0.02),
          Text(
            "Featured Categories",
            style: TextStyle(
              color: Colors.yellow.shade900,
              fontWeight: FontWeight.bold,
              letterSpacing: .5,
              fontSize: size.height * 0.03,
              fontFamily: GoogleFonts.outfit().fontFamily,
            ),
          ),

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
                    onTap:
                        () => Navigator.of(context).push(
                          _elegantRoute(
                            FeaturedProducts(
                              category:
                                  interfaceController
                                      .largeCategoryTitles[index],
                            ),
                          ),
                        ),
                    title: interfaceController.largeCategoryTitles[index],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      backgroundColor: Colors.yellow.shade700,
      onPressed: () {
        Navigator.of(context).push(_elegantRoute(ChatbotPage()));
      },
      child: Icon(Icons.chat_rounded, color: Colors.white),
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
