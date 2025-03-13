import 'package:auth_screens/Model/product_model.dart';
import 'package:flutter/material.dart';

class InputControllers {
  //  Variables
  final List<Product> cartItems = [];
  String sortOption = 'Default';
  //  TEXT INPUT CONTROLLERS
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
}
