import 'package:flutter/material.dart';

class InvoiceMain extends StatefulWidget {
  const InvoiceMain({Key? key}) : super(key: key);

  @override
  _InvoiceMainState createState() => _InvoiceMainState();
}

class _InvoiceMainState extends State<InvoiceMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Invoice'),
      ),
    );
  }
}
