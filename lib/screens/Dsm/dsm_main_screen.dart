//import 'package:bsmart_pwa/utilities/menu_widget.dart';
import 'package:bsmart_pwa/utilities/menu_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DsmMainScreen extends StatefulWidget {
  const DsmMainScreen({Key? key}) : super(key: key);

  @override
  _DsmMainScreenState createState() => _DsmMainScreenState();
}

class _DsmMainScreenState extends State<DsmMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('District Manager Application'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(children: [
          Center(
            child: (Text('Hell World!')),
          ),
        ]),
      ),
      drawer: Menu(),
    );
  }
}
