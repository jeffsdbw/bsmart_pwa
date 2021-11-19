import 'package:bsmart_pwa/screens/Dsm/address_main.dart';
import 'package:bsmart_pwa/screens/Dsm/invoice_main.dart';
import 'package:bsmart_pwa/screens/Dsm/member_main.dart';
import 'package:bsmart_pwa/screens/Dsm/others_info_main.dart';
//import 'package:bsmart_pwa/screens/Dsm/receipt_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RepInfoMain extends StatefulWidget {
  const RepInfoMain({Key? key}) : super(key: key);

  @override
  _RepInfoMainState createState() => _RepInfoMainState();
}

class _RepInfoMainState extends State<RepInfoMain> {
  late SharedPreferences prefs;
  int _selectedIndex = 0;
  bool _isIos = false, _isIPhoneX = false, _checkIPhoneX = false;
  String repCode = 'Member Information';
  List<Widget> _pageWidget = <Widget>[
    MemberMain(),
    InvoiceMain(),
    //ReceiptMain(),
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
      label: 'รายการ',
    ),
    /*BottomNavigationBarItem(
      icon: Icon(Icons.apps),
      label: 'ใบส่งของ',
    ),*/
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

  void checkIPhoneX() {
    _checkIPhoneX = true;
    if (defaultTargetPlatform.toString().toLowerCase().contains("ios") ==
        true) {
      _isIos = true;
    }
    setState(() {});
  }

  /*
  @override
  initState() {
    // at the beginning, all users are shown
    checkIPhoneX();
    super.initState();
  }
  */

  Future<Null> getPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      repCode = (prefs.getString('repCode') ?? 'Member Information');
    });
  }

  @override
  initState() {
    // at the beginning, all users are shown
    getPrefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_checkIPhoneX == false) {
      checkIPhoneX();
      if (_isIos == true) {
        var size = MediaQuery.of(context).size;
        if (size.height >= 812.0 || size.width >= 812.0) {
          _isIPhoneX = true;
        } else {}
      }
    }
    return _isIPhoneX
        ? Container(
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: SafeArea(
                child: Scaffold(
                  appBar: AppBar(
                    title: Text(
                        'รหัสสมาชิก ' + repCode), //Text('Member Information'),
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
                ),
              ),
            ),
          )
        : SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title:
                    Text('รหัสสมาชิก ' + repCode), //Text('Member Information'),
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
            ),
          );
  }
}
