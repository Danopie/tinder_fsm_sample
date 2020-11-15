import 'package:flutter/material.dart';

class PaymentCompletedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Purchase completed"),
            Container(
              height: 12,
            ),
            Icon(
              Icons.check,
              color: Colors.green,
            )
          ],
        ),
      ),
    ));
  }
}
