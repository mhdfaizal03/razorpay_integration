import 'package:hive/hive.dart';
part 'item_models.g.dart';

class Item {
  final String name;
  final String? image;
  final int price;

  Item({required this.name, required this.price, required this.image});
}

List<Item> items = [
  Item(
      name: 'IQOO Z9x 5G',
      image:
          'https://m.media-amazon.com/images/I/411G1EtoIIL._AC_SR300,300.jpg',
      price: 12998),
  Item(
      name: 'POCO M6 Pro 5G',
      image:
          'https://m.media-amazon.com/images/I/41GDzhhheKL._AC_SR300,300.jpg',
      price: 9999),
  Item(
      name: 'Narzo 70x 5G',
      image:
          'https://www.jiomart.com/images/product/original/rv0eb044tn/realme-narzo-70x-5g-6gb-ram-128gb-rom-ice-blue-smartphone-product-images-orv0eb044tn-p608949202-0-202405091539.jpg?im=Resize=(360,360)',
      price: 15999),
  Item(
      name: 'IQOO NEO 9 Pro',
      image: 'https://m.media-amazon.com/images/I/41m-C1HHkIL._SR290,290_.jpg',
      price: 36999),
  // Add more items as needed
];

@HiveType(typeId: 0)
class CartItem {
  @HiveField(0)
  String image;

  @HiveField(1)
  String phoneName;

  @HiveField(2)
  int amount;

  CartItem(
      {required this.image, required this.phoneName, required this.amount});
}

List<CartItem> cartItems = [];
