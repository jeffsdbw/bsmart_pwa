import 'dart:ui';

import 'package:flutter/material.dart';

class InvoiceDetail extends StatelessWidget {
  const InvoiceDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายละเอียดใบส่งของ'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'Invoice Detail',
          style: TextStyle(
              color: Colors.blue, fontSize: 30.0, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
