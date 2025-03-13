// ignore_for_file: deprecated_member_use

import 'package:auth_screens/Controllers/API%20Services/Thrift%20Store/api_services.dart';
import 'package:auth_screens/Controllers/input_controllers.dart';
import 'package:auth_screens/Model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatefulWidget {
  final String title;
  const ProductPage({super.key, required this.title});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  //  Instance for Input Controller
  final InputControllers inputController = InputControllers();
  // state variables

  // Cache for products to avoid unnecessary API calls
  List<Product>? _cachedProducts;
  List<Product> _filteredProducts = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Add listener to search controller for efficient filtering
    inputController.searchController.addListener(_filterProducts);
    // Initial data fetch
    _fetchProducts();
  }

  @override
  void dispose() {
    // Clean up resources
    inputController.searchController.removeListener(_filterProducts);
    inputController.searchController.dispose();
    super.dispose();
  }

  // Fetch products once and cache them
  Future<void> _fetchProducts() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final apiServices = Provider.of<ApiServices>(context, listen: false);
      final products = await apiServices.fetchData();

      setState(() {
        _cachedProducts = products;
        _isLoading = false;
        // Apply initial filtering and sorting
        _filterProducts();
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  // Filter products based on search text and apply sorting
  void _filterProducts() {
    if (_cachedProducts == null) return;

    final searchText = inputController.searchController.text.toLowerCase();

    setState(() {
      // Filter by search text
      _filteredProducts =
          _cachedProducts!.where((product) {
            return product.title.toLowerCase().contains(searchText);
          }).toList();

      // Apply sorting
      _sortProducts();
    });
  }

  // Sort products based on selected option
  void _sortProducts() {
    switch (inputController.sortOption) {
      case 'Price: Low to High':
        _filteredProducts.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'Price: High to Low':
        _filteredProducts.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'Rating':
        _filteredProducts.sort(
          (a, b) => b.rating.rate.compareTo(a.rating.rate),
        );
        break;
      default:
        // Keep original order
        break;
    }
  }

  // Add product to cart with optimized state update
  void _addToCart(Product product) {
    setState(() {
      inputController.cartItems.add(product);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${product.title} added to cart"),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: "VIEW CART",
          textColor: Colors.white,
          onPressed: _showCartDialog,
        ),
      ),
    );
  }

  // Show cart dialog with optimized UI
  void _showCartDialog() {
    showDialog(
      context: context,
      builder: (context) => _buildCartDialog(context),
    );
  }

  // Extract cart dialog building for better code organization
  Widget _buildCartDialog(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.shopping_cart, color: Colors.yellow.shade800),
          const SizedBox(width: 10),
          const Text("Your Cart"),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child:
            inputController.cartItems.isEmpty
                ? _buildEmptyCartView()
                : _buildCartItemsList(),
      ),
      actions: [
        if (inputController.cartItems.isNotEmpty) ...[
          Text(
            "Total: \$${_calculateTotal().toStringAsFixed(2)}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(width: 20),
        ],
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Close"),
        ),
        if (inputController.cartItems.isNotEmpty)
          ElevatedButton(
            onPressed: _handleCheckout,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow.shade800,
              foregroundColor: Colors.white,
            ),
            child: const Text("Checkout"),
          ),
      ],
    );
  }

  // Calculate cart total
  double _calculateTotal() {
    return inputController.cartItems.fold(0.0, (sum, item) => sum + item.price);
  }

  // Empty cart view
  Widget _buildEmptyCartView() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.shopping_cart_outlined,
            size: 50,
            color: Colors.grey,
          ),
          const SizedBox(height: 20),
          Text(
            "Your cart is empty",
            style: TextStyle(color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  // Cart items list
  Widget _buildCartItemsList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: inputController.cartItems.length,
      itemBuilder: (context, index) {
        final item = inputController.cartItems[index];
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.network(
              item.image,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: 50,
                  height: 50,
                  color: Colors.grey.shade200,
                  child: Center(
                    child: CircularProgressIndicator(
                      value:
                          loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                      strokeWidth: 2,
                      color: Colors.yellow.shade800,
                    ),
                  ),
                );
              },
            ),
          ),
          title: Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Text("\$${item.price.toStringAsFixed(2)}"),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _removeCartItem(index),
          ),
        );
      },
    );
  }

  // Remove item from cart
  void _removeCartItem(int index) {
    setState(() {
      inputController.cartItems.removeAt(index);
    });
    Navigator.pop(context);
    if (inputController.cartItems.isNotEmpty) {
      _showCartDialog();
    }
  }

  // Handle checkout
  void _handleCheckout() {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Checkout functionality coming soon!"),
        backgroundColor: Colors.yellow.shade800,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: _buildAppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.025,
          vertical: height * 0.02,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            _buildSearchBar(width),

            const SizedBox(height: 15),

            // Header with sort options
            _buildHeaderWithSortOptions(height),

            const SizedBox(height: 10),

            // Product display - main content
            Expanded(
              child:
                  _isLoading
                      ? _buildLoadingIndicator()
                      : _errorMessage != null
                      ? _buildErrorView()
                      : _cachedProducts == null || _cachedProducts!.isEmpty
                      ? _buildNoProductsView()
                      : _filteredProducts.isEmpty
                      ? _buildNoMatchingProductsView()
                      : _buildProductsGrid(),
            ),
          ],
        ),
      ),
    );
  }

  // Build app bar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.grey.shade100,
      iconTheme: IconThemeData(color: Colors.yellow.shade800),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.yellow.shade800.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.shopping_bag, color: Colors.yellow.shade800),
          ),
          const SizedBox(width: 10),
          Text(
            "Thrift Store",
            style: TextStyle(
              fontFamily: GoogleFonts.lobsterTwo().fontFamily,
              color: Colors.yellow.shade800,
              fontWeight: FontWeight.bold,
              letterSpacing: .5,
            ),
          ),
        ],
      ),
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_ios),
      ),
      actions: [
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              onPressed: _showCartDialog,
              icon: Icon(Icons.shopping_cart, color: Colors.yellow.shade800),
            ),
            if (inputController.cartItems.isNotEmpty)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    inputController.cartItems.length.toString(),
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
      ],
    );
  }

  // Build search bar
  Widget _buildSearchBar(double width) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
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
            borderSide: BorderSide(color: Colors.yellow.shade800),
          ),
          labelText: "Search for products",
          labelStyle: const TextStyle(color: Colors.black),
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
        ),
      ),
    );
  }

  // Build header with sort options
  Widget _buildHeaderWithSortOptions(double height) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Products",
          style: TextStyle(
            color: Colors.black.withOpacity(0.65),
            fontWeight: FontWeight.bold,
            letterSpacing: .5,
            fontSize: height * 0.03,
            fontFamily: GoogleFonts.outfit().fontFamily,
          ),
        ),
        // Sort dropdown
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: DropdownButton<String>(
            value: inputController.sortOption,
            underline: const SizedBox(),
            icon: Icon(Icons.sort, color: Colors.yellow.shade800),
            items: const [
              DropdownMenuItem<String>(
                value: 'Default',
                child: Text("Default"),
              ),
              DropdownMenuItem<String>(
                value: 'Price: Low to High',
                child: Text("Price: Low to High"),
              ),
              DropdownMenuItem<String>(
                value: 'Price: High to Low',
                child: Text("Price: High to Low"),
              ),
              DropdownMenuItem<String>(value: 'Rating', child: Text("Rating")),
            ],
            onChanged: (value) {
              if (value != null && value != inputController.sortOption) {
                setState(() {
                  inputController.sortOption = value;
                  _sortProducts();
                });
              }
            },
          ),
        ),
      ],
    );
  }

  // Loading indicator
  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.yellow.shade900),
          const SizedBox(height: 20),
          Text(
            "Loading products...",
            style: TextStyle(
              color: Colors.grey.shade700,
              fontFamily: GoogleFonts.outfit().fontFamily,
            ),
          ),
        ],
      ),
    );
  }

  // Error view
  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 60, color: Colors.red),
          const SizedBox(height: 20),
          Text(
            "Error loading products",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red.shade800,
            ),
          ),
          const SizedBox(height: 10),
          Text(_errorMessage ?? "Unknown error"),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _fetchProducts,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow.shade800,
              foregroundColor: Colors.white,
            ),
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }

  // No products view
  Widget _buildNoProductsView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.shopping_bag_outlined, size: 60, color: Colors.grey),
          const SizedBox(height: 20),
          Text(
            "No products found",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }

  // No matching products view
  Widget _buildNoMatchingProductsView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 60, color: Colors.grey),
          const SizedBox(height: 20),
          Text(
            "No matching products found",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Try adjusting your search or filters",
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  // Products grid
  Widget _buildProductsGrid() {
    return MasonryGridView.builder(
      gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: _filteredProducts.length,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      itemBuilder:
          (context, index) => _buildProductCard(_filteredProducts[index]),
    );
  }

  // Product card
  Widget _buildProductCard(Product data) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image with loading indicator
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: Stack(
              children: [
                _buildProductImage(data),
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
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      data.category,
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
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  data.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    fontFamily: GoogleFonts.outfit().fontFamily,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),

                // Price
                Text(
                  "\$${data.price.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.yellow.shade900,
                    fontFamily: GoogleFonts.outfit().fontFamily,
                  ),
                ),
                const SizedBox(height: 8),

                // Rating
                _buildRatingStars(data.rating),
                const SizedBox(height: 8),

                // Description
                Text(
                  data.description,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),

                // Add to cart button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _addToCart(data),
                    icon: const Icon(Icons.add_shopping_cart, size: 16),
                    label: const Text("Add to Cart"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow.shade800,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Product image
  Widget _buildProductImage(Product data) {
    return Image.network(
      data.image,
      fit: BoxFit.cover,
      width: double.infinity,
      height: 150,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          height: 150,
          width: double.infinity,
          color: Colors.grey.shade200,
          child: Center(
            child: CircularProgressIndicator(
              value:
                  loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
              color: Colors.yellow.shade800,
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          height: 150,
          width: double.infinity,
          color: Colors.grey.shade200,
          child: const Icon(
            Icons.image_not_supported,
            color: Colors.grey,
            size: 50,
          ),
        );
      },
    );
  }

  // Rating stars
  Widget _buildRatingStars(Rating rating) {
    return Row(
      children: [
        ...List.generate(5, (i) {
          return Icon(
            i < rating.rate.floor()
                ? Icons.star
                : i < rating.rate
                ? Icons.star_half
                : Icons.star_border,
            color: Colors.amber,
            size: 16,
          );
        }),
        const SizedBox(width: 4),
        Text(
          "(${rating.count})",
          style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
        ),
      ],
    );
  }
}
