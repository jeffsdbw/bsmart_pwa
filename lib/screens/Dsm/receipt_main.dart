import 'package:flutter/material.dart';

class ReceiptMain extends StatefulWidget {
  const ReceiptMain({Key? key}) : super(key: key);

  @override
  _ReceiptMainState createState() => _ReceiptMainState();
}

class _ReceiptMainState extends State<ReceiptMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Receipt'),
      ),
    );
  }
}
