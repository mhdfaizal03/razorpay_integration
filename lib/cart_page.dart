import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:razorpay/item_models.dart';
import 'razorpay_page.dart';

class CartPage extends StatelessWidget {
  final Box<CartItem> cartBox = Hive.box<CartItem>('cart');

  CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Group items by their name and count them
    Map<String, List<int>> groupedItems = {};
    for (int i = 0; i < cartBox.length; i++) {
      final item = cartBox.getAt(i);
      if (groupedItems.containsKey(item!.phoneName)) {
        groupedItems[item.phoneName]!.add(i);
      } else {
        groupedItems[item.phoneName] = [i];
      }
    }

    int totalAmount = groupedItems.values.fold(0, (sum, itemList) {
      final item = cartBox.getAt(itemList.first);
      return sum + (item!.amount * itemList.length);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: ValueListenableBuilder(
        valueListenable: cartBox.listenable(),
        builder: (context, Box<CartItem> box, _) {
          if (box.isEmpty) {
            return const Center(child: Text('Your cart is empty'));
          }
          return ListView.builder(
            itemCount: groupedItems.length,
            itemBuilder: (context, index) {
              final itemName = groupedItems.keys.elementAt(index);
              final itemIndices = groupedItems[itemName]!;
              final item = cartBox.getAt(itemIndices.first);

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: Image.network(item!.image),
                  title: Text(item.phoneName),
                  subtitle: Text(
                      "₹${item.amount.toString()} x ${itemIndices.length} = ₹${item.amount * itemIndices.length}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle),
                    onPressed: () {
                      for (var i in itemIndices) {
                        cartBox.deleteAt(i);
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        height: 60,
        color: Colors.transparent,
        elevation: 1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                cartBox.clear();
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.blue[300]),
                  shape: const MaterialStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))))),
              child: const Text('Clear Cart',
                  style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              onPressed: () {
                // Implement your checkout logic here

                totalAmount > 0
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                RazorPayPage(amoutPay: totalAmount)))
                    : null;
              },
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.green),
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))))),
              child:
                  const Text('Checkout', style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}
