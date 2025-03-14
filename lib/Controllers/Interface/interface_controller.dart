import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class InterfaceController extends ChangeNotifier {
  //  List of images for carousel view on interface page
  final List<String> _carouselItems = [
    "Assets/Carousel/carousel1.jpg",
    "Assets/Carousel/carousel2.jpg",
    "Assets/Carousel/carousel3.jpg",
    "Assets/Carousel/carousel4.jpg",
    "Assets/Carousel/carousel5.jpg",
  ];

  //  List of images for large category tiles on interface page
  final List<String> _largeCategoryItems = [
    "Assets/Categories/Clothing.jpeg",
    "Assets/Categories/Cosmetics.jpeg",
    "Assets/Categories/Female Footwear.jpeg",
    "Assets/Categories/Male Footwear.jpeg",
    "Assets/Categories/Female Accessories.jpeg",
    "Assets/Categories/Male Accessories.jpeg",
    "Assets/Categories/Men Clothing.jpeg",
    "Assets/Categories/Women Clothing.jpeg",
    "Assets/Categories/Furniture.jpeg",
    "Assets/Categories/Smoke.jpeg",
  ];

  //  List of titles for large category tiles on interface page
  final List<String> _largeCategoryTitles = [
    "Clothing",
    "Cosmetics",
    "Female Footwear",
    "Male Footwear",
    "Female Gear",
    "Male Gear",
    "Men Wear",
    "Women Wear",
    "Furniture",
    "Smoke",
  ];

  //  Instance for Firebase Firestore
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  //  Getters
  FirebaseFirestore get fireStore => _fireStore;
  List<String> get largeCategoryTitles => _largeCategoryTitles;
  List<String> get largeCategoryItems => _largeCategoryItems;
  List<String> get carouselItems => _carouselItems;
}
