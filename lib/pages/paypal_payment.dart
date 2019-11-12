import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class PayPalPayment extends StatefulWidget {
  @override
  _PayPalPaymentState createState() => _PayPalPaymentState();
}

class _PayPalPaymentState extends State<PayPalPayment> {
  String test = "Test Charge";

  int amount = 100;

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      appBar: AppBar(),
      url: new Uri.dataFromString('''
      <html>
        <head>
         <meta name="viewport" content="width=device-width">
        </head>
        <center>
          <body>      
            <form action="Your Server" method="POST">
              <script
                src="https://checkout.stripe.com/checkout.js" class="stripe-button"
                data-key="pk_test_key"
                data-amount="$amount"
                data-name="$test"
                data-description="My Order"
                data-image="https://stripe.com/img/documentation/checkout/marketplace.png"
                data-locale="auto"
                data-currency="eur">
              </script>
            </form>            
          </body>
        </center>
      </html>
            ''', mimeType: 'text/html').toString(),
    );
  }
}
