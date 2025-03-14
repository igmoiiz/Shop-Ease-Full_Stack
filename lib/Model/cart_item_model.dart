class CartItem {
  final String id;
  final String title;
  final double price;
  final String image;
  int quantity;
  final String category;

  CartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.quantity,
    required this.category,
  });
}
