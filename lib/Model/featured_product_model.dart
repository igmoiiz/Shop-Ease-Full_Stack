import 'package:cloud_firestore/cloud_firestore.dart';

class FeaturedProduct {
  final String id;
  final String title;
  final String image;
  final double price;
  final String description;

  FeaturedProduct({
    required this.id,
    required this.title,
    required this.image,
    required this.price,
    required this.description,
  });

  factory FeaturedProduct.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return FeaturedProduct(
      id: doc.id,
      title: data['title'] ?? '',
      image: data['image'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      description: data['description'] ?? '',
    );
  }
}
