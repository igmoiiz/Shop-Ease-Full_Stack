// ignore_for_file: deprecated_member_use

import 'package:auth_screens/Controllers/Database/database_services.dart';
import 'package:auth_screens/Controllers/Interface/interface_controller.dart';
import 'package:auth_screens/Controllers/input_controllers.dart';
import 'package:auth_screens/View/Cart/cart_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:auth_screens/Controllers/Cart%20Services/cart_services.dart';
import 'package:auth_screens/Model/featured_product_model.dart';

class FeaturedProducts extends StatelessWidget {
  final String category;
  FeaturedProducts({super.key, required this.category});

  //  Instance for Input Controller
  final InputControllers inputController = InputControllers();
  //  Instance for Database Services
  final DatabaseServices databaseServices = DatabaseServices();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cartServices = Provider.of<CartServices>(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        iconTheme: IconThemeData(color: Colors.yellow.shade800),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.yellow.shade800.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.shopping_bag, color: Colors.yellow.shade800),
            ),
            const SizedBox(width: 10),
            Text(
              category,
              style: TextStyle(
                fontFamily: GoogleFonts.urbanist().fontFamily,
                color: Colors.yellow.shade800,
                fontWeight: FontWeight.bold,
                letterSpacing: .5,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.025,
          vertical: size.height * 0.02,
        ),
        child: Column(
          children: [
            // Search field
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.025),
              child: TextField(
                controller: inputController.searchController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade600),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade600),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.yellow.shade800,
                      width: 2,
                    ),
                  ),
                  labelText: "Search for products",
                  labelStyle: const TextStyle(color: Colors.black54),
                  prefixIcon: Icon(Icons.search, color: Colors.yellow.shade800),
                  suffixIcon:
                      inputController.searchController.text.isNotEmpty
                          ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              inputController.searchController.clear();
                            },
                          )
                          : null,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.02),

            // Products grid
            Expanded(
              child: Consumer<InterfaceController>(
                builder: (context, value, child) {
                  return StreamBuilder(
                    stream: value.fireStore.collection(category).snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Colors.yellow.shade800,
                          ),
                        );
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Colors.red.shade400,
                                size: 48,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "Error: ${snapshot.error}",
                                style: const TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        );
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.shopping_basket_outlined,
                                color: Colors.grey.shade400,
                                size: 48,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "No products found in $category",
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        );
                      }

                      return GridView.builder(
                        itemCount: snapshot.data!.docs.length,
                        padding: const EdgeInsets.only(bottom: 16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.65,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                        itemBuilder: (context, index) {
                          final data = snapshot.data!.docs[index];
                          final product = FeaturedProduct(
                            id: data.id,
                            title: data['title'] ?? '',
                            image: data['image'] ?? '',
                            price: (data['price'] ?? 0.0).toDouble(),
                            description: data['description'] ?? '',
                            category: data['category'] ?? category,
                          );
                          final isInCart = cartServices.isInCart(product.id);
                          final quantity = cartServices.getQuantity(product.id);
                          return Card(
                            elevation: 2,
                            shadowColor: Colors.black26,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Product image with loading indicator
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12),
                                  ),
                                  child: Stack(
                                    children: [
                                      Image.network(
                                        data["image"],
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: 140,
                                        loadingBuilder: (
                                          context,
                                          child,
                                          loadingProgress,
                                        ) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return Container(
                                            height: 140,
                                            width: double.infinity,
                                            color: Colors.grey.shade200,
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                value:
                                                    loadingProgress
                                                                .expectedTotalBytes !=
                                                            null
                                                        ? loadingProgress
                                                                .cumulativeBytesLoaded /
                                                            loadingProgress
                                                                .expectedTotalBytes!
                                                        : null,
                                                color: Colors.yellow.shade800,
                                                strokeWidth: 3,
                                              ),
                                            ),
                                          );
                                        },
                                        errorBuilder: (
                                          context,
                                          error,
                                          stackTrace,
                                        ) {
                                          return Container(
                                            height: 140,
                                            width: double.infinity,
                                            color: Colors.grey.shade200,
                                            child: const Icon(
                                              Icons.image_not_supported,
                                              color: Colors.grey,
                                              size: 50,
                                            ),
                                          );
                                        },
                                      ),
                                      // Category badge
                                      Positioned(
                                        top: 8,
                                        left: 8,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.yellow.shade800,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                  0.2,
                                                ),
                                                blurRadius: 4,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Text(
                                            data['category'],
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Product details
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Title
                                        Text(
                                          data['title'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            fontFamily:
                                                GoogleFonts.outfit().fontFamily,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 6),

                                        // Price
                                        Text(
                                          "Rs.${data['price']}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.yellow.shade900,
                                            fontFamily:
                                                GoogleFonts.outfit().fontFamily,
                                          ),
                                        ),
                                        const SizedBox(height: 6),

                                        // Description
                                        Expanded(
                                          child: Text(
                                            data['description'],
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade700,
                                            ),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),

                                        // Add to cart button
                                        SizedBox(
                                          width: double.infinity,
                                          child:
                                              isInCart
                                                  ? Row(
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          height: 36,
                                                          decoration: BoxDecoration(
                                                            color:
                                                                Colors
                                                                    .yellow
                                                                    .shade800,
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  8,
                                                                ),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              IconButton(
                                                                icon: const Icon(
                                                                  Icons.remove,
                                                                  color:
                                                                      Colors
                                                                          .white,
                                                                  size: 16,
                                                                ),
                                                                onPressed:
                                                                    () => cartServices
                                                                        .decrementQuantity(
                                                                          product
                                                                              .id,
                                                                        ),
                                                                padding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                constraints:
                                                                    const BoxConstraints(),
                                                              ),
                                                              Text(
                                                                quantity
                                                                    .toString(),
                                                                style: const TextStyle(
                                                                  color:
                                                                      Colors
                                                                          .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              IconButton(
                                                                icon: const Icon(
                                                                  Icons.add,
                                                                  color:
                                                                      Colors
                                                                          .white,
                                                                  size: 16,
                                                                ),
                                                                onPressed:
                                                                    () => cartServices
                                                                        .incrementQuantity(
                                                                          product
                                                                              .id,
                                                                        ),
                                                                padding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                constraints:
                                                                    const BoxConstraints(),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                  : ElevatedButton.icon(
                                                    onPressed: () {
                                                      // Add to cart with animation
                                                      cartServices.addToCart(
                                                        product,
                                                      );

                                                      // Show a snackbar
                                                      ScaffoldMessenger.of(
                                                        context,
                                                      ).showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                            '${product.title} added to cart',
                                                          ),
                                                          duration:
                                                              const Duration(
                                                                seconds: 2,
                                                              ),
                                                          action: SnackBarAction(
                                                            label: 'View Cart',
                                                            onPressed: () {
                                                              // Navigate to cart page
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (
                                                                        context,
                                                                      ) =>
                                                                          CartPage(),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    icon: const Icon(
                                                      Icons.add_shopping_cart,
                                                      size: 16,
                                                    ),
                                                    label: const Text(
                                                      "Add to Cart",
                                                    ),
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          Colors
                                                              .yellow
                                                              .shade800,
                                                      foregroundColor:
                                                          Colors.white,
                                                      elevation: 2,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                      ),
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            vertical: 8,
                                                          ),
                                                    ),
                                                  ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
