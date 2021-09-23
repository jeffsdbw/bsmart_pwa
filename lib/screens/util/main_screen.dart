import 'package:bsmart_pwa/utilities/constants.dart';
import 'package:bsmart_pwa/utilities/menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String userID = 'User ID';
  String userName = 'User Name';

  _getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userID = (prefs.getString('userID') ?? 'XXX');
      userName = (prefs.getString('userName') ?? 'Unknown User');
    });
    //userName = 'Hello ' + (prefs.getString('userName') ?? 'Unknown');
  }

  @override
  void initState() {
    _getUserName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'BSMART',
          style: TextStyle(color: kTextHeader),
        ),
        centerTitle: true,
      ),
      body: Container(
        alignment: FractionalOffset.center,
        child: ListView(
          children: [
            SizedBox(
              height: 20.0,
            ),
            Text(
              'Welcome to',
              style: TextStyle(
                  color: Colors.blue[900],
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              'BSMART',
              style: TextStyle(
                  color: Colors.blue[900],
                  fontSize: 50.0,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              'Application.',
              style: TextStyle(
                  color: Colors.blue[900],
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 15.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  //color: Colors.lightBlue,
                  //padding: EdgeInsets.only(right: 300.0),
                  width: 300.0,
                  child: ListTile(
                    leading: Icon(
                      Icons.emoji_emotions_outlined,
                      size: 50.0,
                    ),
                    title: Text(
                      userID,
                      style: TextStyle(
                          fontSize: 25.0,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      userName,
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            /*ListTile(
              leading: Icon(
                Icons.emoji_emotions_outlined,
                size: 50.0,
              ),
              title: Text(
                userID,
                style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                userName,
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
              ),
            ),*/
            SizedBox(
              height: 15.0,
            ),
            new Flex(
              direction: Axis.vertical,
              children: <Widget>[
                Image.asset('assets/images/bw.jpg'),
              ],
            ),
            SizedBox(
              height: 15.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  //color: Colors.lightBlue,
                  //padding: EdgeInsets.only(right: 300.0),
                  //width: 500.0,
                  child: Text(
                    'Copyright © BSMART Team.',
                    style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.blue[900],
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  //color: Colors.lightBlue,
                  //padding: EdgeInsets.only(right: 300.0),
                  //width: 500.0,
                  child: Text(
                    'All rights reserved.',
                    style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.blue[900],
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            /*Text(
              'Copyright © BSMART Team. All rights reserved. ',
              style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.blue[900],
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),*/
            /*Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Image.asset(
                    "assets/images/bw.jpg",
                    width: 400.0,
                  ),
                ),
              ],
            ),*/
          ],
        ),
      ),
      drawer: Menu(),
    );
  }
}
