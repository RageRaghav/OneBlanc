class CartItem {
  final int cuisineID;
  final int itemID;
  final String name;
  final int price;
  int quantity;

  CartItem({required this.cuisineID, required this.itemID, required this.name, required this.price, this.quantity = 1});
}
