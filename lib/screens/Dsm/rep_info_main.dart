import 'package:bsmart_pwa/screens/Dsm/address_main.dart';
import 'package:bsmart_pwa/screens/Dsm/invoice_main.dart';
import 'package:bsmart_pwa/screens/Dsm/member_main.dart';
import 'package:bsmart_pwa/screens/Dsm/others_info_main.dart';
import 'package:bsmart_pwa/screens/Dsm/receipt_main.dart';
import 'package:flutter/material.dart';

class RepInfoMain extends StatefulWidget {
  const RepInfoMain({Key? key}) : super(key: key);

  @override
  _RepInfoMainState createState() => _RepInfoMainState();
}

class _RepInfoMainState extends State<RepInfoMain> {
  int _selectedIndex = 0;

  List<Widget> _pageWidget = <Widget>[
    MemberMain(),
    InvoiceMain(),
    ReceiptMain(),
    AddressMain(),
    OthersInfoMain(),
  ];

  List<BottomNavigationBarItem> _menuBar = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.account_circle),
      label: 'สมาชิก',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.description),
      label: 'ใบส่งของ',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.payment),
      label: 'ชำระเงิน',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'ที่อยู่',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.format_list_bulleted),
      label: 'ข้อมูลอื่นๆ',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Member Infomation'),
        centerTitle: true,
      ),
      body: _pageWidget.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: _menuBar,
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
