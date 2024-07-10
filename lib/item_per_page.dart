import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:razorpay/item_models.dart';
import 'package:razorpay/razorpay_page.dart';
import 'cart_page.dart'; // Make sure to import the CartPage

class ItemsPerPage extends StatelessWidget {
  String image;
  String phoneName;
  int amount;
  ItemsPerPage(
      {super.key,
      required this.image,
      required this.phoneName,
      required this.amount});

  final Box<CartItem> cartBox = Hive.box<CartItem>('cart');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        height: 60,
        color: Colors.transparent,
        elevation: 1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                final cartItem = CartItem(
                    image: image, phoneName: phoneName, amount: amount);
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('$phoneName added to cart')));
                cartBox.add(cartItem);
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.blue[300]),
                  shape: const MaterialStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))))),
              child: const Text(
                'Cart item',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => RazorPayPage(amoutPay: amount)));
              },
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.green),
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))))),
              child: const Text(
                'Buy now',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Items'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Image.network(image)),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    phoneName,
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text("₹${amount.toString()}",
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
