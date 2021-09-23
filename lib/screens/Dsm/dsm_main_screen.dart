import 'package:flutter/material.dart';
import 'package:bsmart_pwa/utilities/menu_widget.dart';

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
        title: Text('Developer'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'Software Developer',
              style: TextStyle(
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800]),
            ),
          ),
          SizedBox(
            height: 40.0,
          ),
          Image.asset('assets/images/u08.png'),
          SizedBox(
            height: 40.0,
          ),
          Text(
            'Comming Soon!',
            style: TextStyle(
                color: Colors.red, fontSize: 30.0, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      drawer: Menu(),
    );
  }
}
