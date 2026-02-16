import 'package:flutter/material.dart';

class PaymentMethodLogo extends StatelessWidget {
  final String method;
  final double size;
  const PaymentMethodLogo({required this.method, this.size = 24, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (method) {
      case 'MPESA':
        return Image.asset('assets/mpesa.png', width: size, height: size, fit: BoxFit.contain);
      case 'CARD':
        return Row(children: [
          Image.asset('assets/visa.png', width: size, height: size),
          SizedBox(width: 2),
          Image.asset('assets/mastercard.png', width: size, height: size),
          SizedBox(width: 2),
          Image.asset('assets/amex.png', width: size, height: size),
        ]);
      case 'CASH_APP':
        return Image.asset('assets/cashapp.png', width: size, height: size);
      case 'AMAZON_PAY':
        return Image.asset('assets/amazonpay.png', width: size, height: size);
      case 'LINK':
        return Icon(Icons.link, size: size, color: Colors.blue);
      default:
        return Icon(Icons.payment, size: size);
    }
  }
}
