import 'package:flutter/material.dart';

class PayPalPayment extends StatefulWidget {
  @override
  _PayPalPaymentState createState() => _PayPalPaymentState();
}

class _PayPalPaymentState extends State<PayPalPayment> {
  String test = "Test Charge";

  int amount = 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container()
    );
  }
}
