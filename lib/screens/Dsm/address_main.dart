import 'package:flutter/material.dart';

class AddressMain extends StatefulWidget {
  const AddressMain({Key? key}) : super(key: key);

  @override
  _AddressMainState createState() => _AddressMainState();
}

class _AddressMainState extends State<AddressMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Address'),
      ),
    );
  }
}
