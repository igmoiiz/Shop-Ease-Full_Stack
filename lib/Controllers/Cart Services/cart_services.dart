import 'package:auth_screens/Controllers/Authentication/auth_services.dart';
import 'package:auth_screens/Model/cart_item_model.dart';
import 'package:auth_screens/Model/featured_product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CartServices extends ChangeNotifier {
  // List to store cart items
  final List<CartItem> _cartItems = [];

  // Firebase instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Auth services instance to get current user
  final AuthServices _authServices = AuthServices();

  // Getters
  List<CartItem> get cartItems => _cartItems;
  int get itemCount => _cartItems.length;

  // Calculate total price of all items in cart
  double get totalPrice {
    return _cartItems.fold(
      0,
      (total, item) => total + (item.price * item.quantity),
    );
  }

  // Add item to cart
  void addToCart(FeaturedProduct product, {int quantity = 1}) {
    // Check if item already exists in cart
    final existingItemIndex = _cartItems.indexWhere(
      (item) => item.id == product.id,
    );

    if (existingItemIndex >= 0) {
      // Item exists, update quantity
      _cartItems[existingItemIndex].quantity += quantity;
    } else {
      // Add new item
      _cartItems.add(
        CartItem(
          id: product.id,
          title: product.title,
          price: product.price,
          image: product.image,
          quantity: quantity,
          category: product.category,
        ),
      );
    }

    // Notify listeners about the change
    notifyListeners();

    // Show success animation or feedback can be triggered from UI
  }

  // Remove item from cart
  void removeFromCart(String productId) {
    _cartItems.removeWhere((item) => item.id == productId);
    notifyListeners();
  }

  // Update quantity of an item
  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(productId);
      return;
    }

    final index = _cartItems.indexWhere((item) => item.id == productId);
    if (index >= 0) {
      _cartItems[index].quantity = quantity;
      notifyListeners();
    }
  }

  // Increment quantity
  void incrementQuantity(String productId) {
    final index = _cartItems.indexWhere((item) => item.id == productId);
    if (index >= 0) {
      _cartItems[index].quantity++;
      notifyListeners();
    }
  }

  // Decrement quantity
  void decrementQuantity(String productId) {
    final index = _cartItems.indexWhere((item) => item.id == productId);
    if (index >= 0) {
      if (_cartItems[index].quantity > 1) {
        _cartItems[index].quantity--;
      } else {
        removeFromCart(productId);
      }
      notifyListeners();
    }
  }

  // Clear cart
  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  // Check if a product is in cart
  bool isInCart(String productId) {
    return _cartItems.any((item) => item.id == productId);
  }

  // Get quantity of a product in cart
  int getQuantity(String productId) {
    final item = _cartItems.firstWhere(
      (item) => item.id == productId,
      orElse:
          () => CartItem(
            id: productId,
            title: '',
            price: 0,
            image: '',
            quantity: 0,
            category: '',
          ),
    );
    return item.quantity;
  }

  // Checkout process - save order to Firestore
  Future<bool> checkout({
    required String address,
    required String paymentMethod,
  }) async {
    try {
      if (_cartItems.isEmpty) return false;

      // Get current user email
      final userEmail = _authServices.getCurrentUserEmail();
      if (userEmail == null || userEmail.contains("Error")) {
        return false;
      }

      // Create order data
      final orderData = {
        'userEmail': userEmail,
        'orderDate': Timestamp.now(),
        'status': 'pending',
        'totalAmount': totalPrice,
        'address': address,
        'paymentMethod': paymentMethod,
        'items':
            _cartItems
                .map(
                  (item) => {
                    'id': item.id,
                    'title': item.title,
                    'price': item.price,
                    'quantity': item.quantity,
                    'image': item.image,
                    'category': item.category,
                  },
                )
                .toList(),
      };

      // Save to Firestore
      await _firestore.collection('orders').add(orderData);

      // Clear cart after successful checkout
      clearCart();

      return true;
    } catch (e) {
      debugPrint('Error during checkout: $e');
      return false;
    }
  }
}
