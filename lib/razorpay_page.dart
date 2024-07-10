import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorPayPage extends StatefulWidget {
  final int amoutPay;
  const RazorPayPage({super.key, required this.amoutPay});

  @override
  State<RazorPayPage> createState() => _RazorPayPageState();
}

class _RazorPayPageState extends State<RazorPayPage> {
  late Razorpay _razorpay;
  TextEditingController amountController = TextEditingController();

  void openCheckout(int amount) {
    amount = amount * 100; // Convert to paise
    var options = {
      'key': 'rzp_test_1DP5mm0lF5G5ag',
      'amount': amount,
      'name': 'Muhammed Faizal',
      'description': 'Payment for testing',
      'prefill': {
        'contact': '8075374600',
        'email': 'test@gmail.com',
      },
      'external': {
        'wallets': ['paytm'],
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
      Fluttertoast.showToast(
        msg: 'Error: $e',
        toastLength: Toast.LENGTH_LONG,
      );
    }
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg: 'Payment Successfull${response.paymentId!}',
        toastLength: Toast.LENGTH_SHORT);
  }

  void handlePaymentFailure(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: 'Payment Failure${response.message!}',
        toastLength: Toast.LENGTH_SHORT);
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: 'External Wallet ${response.walletName!}',
        toastLength: Toast.LENGTH_SHORT);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentFailure);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Razorpay Payment'),
      ),
      backgroundColor: Colors.grey[300],
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  Image.network(
                    'https://cdn3d.iconscout.com/3d/free/thumb/payment-successful-3543010-2969397.png',
                    width: 300,
                  ),
                  const Text(
                    "Welcome to Razorpay Payment Gateway Integration",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(10),
                      child: Center(
                        child: Text(
                          '₹ ${widget.amoutPay}',
                          style: const TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      )
                      // TextFormField(
                      //   autofocus: false,
                      //   cursorColor: Colors.white,
                      //   decoration: InputDecoration(
                      //     filled: true,
                      //     fillColor: Colors.grey[400],
                      //     hintText: 'Enter amount',
                      //     border: const OutlineInputBorder(
                      //         borderRadius: BorderRadius.all(
                      //           Radius.circular(20),
                      //         ),
                      //         borderSide: BorderSide.none),
                      //     errorStyle: const TextStyle(color: Colors.redAccent),
                      //   ),
                      //   controller: amountController,
                      //   validator: (val) {
                      //     if (val == null || val.isEmpty) {
                      //       return 'Please enter amount to be sent';
                      //     } else {
                      //       return null;
                      //     }
                      //   },
                      // ),

                      ),
                ],
              ),
              const SizedBox(
                height: 100,
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                    backgroundColor:
                        MaterialStatePropertyAll(Colors.blue[300])),
                onPressed: () {
                  setState(() {
                    int amount = widget.amoutPay;
                    openCheckout(amount);
                  });
                },
                child: const Text(
                  'Make Payment',
                  style: TextStyle(color: Colors.black),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
