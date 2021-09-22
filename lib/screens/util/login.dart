import 'dart:ui';
import 'package:bsmart_pwa/screens/util/main_screen.dart';
import 'package:bsmart_pwa/utilities/constants.dart';
import 'package:flutter/cupertino.dart';
//import 'package:bsmart/utilities/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _rememberMe = false;
  bool _chkFirst = true;
  //String _fcmToken = "Hello World!";
  String _userId = 'USER_ID';
  //String _userName = 'USER_NAME';
  String _userPassword = 'USER_PASSWORD';
  //String _msg = 'Hello World!';

  FocusNode _userFocus = new FocusNode();
  FocusNode _passwordFocus = new FocusNode();

  TextEditingController ctrUsername = TextEditingController();
  TextEditingController ctrPassword = TextEditingController();

  late SharedPreferences prefs;

  Future<Null> getPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = (prefs.getString('userID') ?? 'NoID');
      //_userName = (prefs.getString('userName') ?? 'NoName');
      _userPassword = (prefs.getString('userPassword') ?? 'NoPassword');
      //print('Check Pref : $_userId, $_userName, $_userPassword');
    });
    if (_userPassword != 'NoPassword') {
      ctrUsername.text = _userId;
      ctrPassword.text = _userPassword;
      _doLogin();
    }
  }

  /*
  void _getFcmToken(String pFcmToken) {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _fcmToken = pFcmToken;
    });
  }
  */

  Future<Null> doLogin() async {
    /*String serviceUrl = bwWebserviceUrl +
        'checkLogin.php?user=' +
        ctrUsername.text +
        '&password=' +
        ctrPassword.text +
        '&appid=BSMART';
    print('Service:$serviceUrl');*/
    //_setDisp(serviceUrl);

    /*final uri = Uri.https(
        bwWebserviceUrl +
            'checkLogin.php?user=' +
            ctrUsername.text +
            '&password=' +
            ctrPassword.text +
            '&appid=BSMART',
        '');*/

    //final response = await http.post(uri);

    final response = await http.post(
      Uri.parse(bwWebserviceUrl +
          'checkLogin.php?user=' +
          ctrUsername.text +
          '&password=' +
          ctrPassword.text +
          '&appid=BSMART'),
    );

    //print(response.body);
    //_setDisp(response.body);

    if (response.statusCode == 200) {
      Map<String, dynamic> map = jsonDecode(response.body);
      String status = map['results']['status'];
      if (status == '1') {
        String userID = map['results']['id'];
        String userName = map['results']['name'];
        String userPassword = ctrPassword.text;
        if (_rememberMe == true) {
          //final prefs = await SharedPreferences.getInstance();
          //prefs = await SharedPreferences.getInstance();
          prefs.setString('userID', userID);
          prefs.setString('userName', userName);
          prefs.setString('userPassword', userPassword);
          prefs.setString('server', bwWebserviceUrl);
        } else {
          //prefs = await SharedPreferences.getInstance();
          prefs.setString('userID', userID);
          prefs.setString('userName', userName);
          prefs.setString('server', bwWebserviceUrl);
        }

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainScreen()));
      } else {
        String vMsg = map['results']['message'];
        showDialog<Null>(
            context: context,
            builder: (BuildContext context) {
              return SimpleDialog(
                title: Text(
                  vMsg,
                ),
                children: <Widget>[
                  SimpleDialogOption(
                    onPressed: () {
                      //print('Login Error:' + vMsg);
                      Navigator.pop(context);
                    },
                    child: Center(
                      child: const Text('OK',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ),
                ],
              );
            });
      }
    } else {
      showDialog<Null>(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              title: const Text(
                'Connection Error!!!',
              ),
              children: <Widget>[
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Center(
                    child: const Text('OK',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ),
              ],
            );
          });
    }
  }

  void _doLogin() {
    //print('Check Token : $_fcmToken');
    if (ctrUsername.text.isEmpty || ctrPassword.text.isEmpty) {
      showDialog<Null>(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              title: const Text(
                'Please fill User Account and Password!!!',
              ),
              children: <Widget>[
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Center(
                    child: const Text('OK',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ),
              ],
            );
          });
    } else {
      doLogin();
    }
  }

  Widget _buildAccountTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'User Account',
          style: kLabelStyle,
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 50.0,
          child: TextFormField(
            controller: ctrUsername,
            focusNode: _userFocus,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.characters,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.account_box,
                color: Colors.white,
              ),
              hintText: 'Enter User Account',
              hintStyle: kHintTextStyle,
            ),
            onEditingComplete: () {
              ctrUsername.text = ctrUsername.text.toUpperCase();
            },
            onFieldSubmitted: (v) {
              //_userFocus.unfocus();
              FocusScope.of(context).requestFocus(_passwordFocus);
              ctrUsername.text = ctrUsername.text.toUpperCase();
              //print('Check User:'+ctrUsername.text);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Password',
          style: kLabelStyle,
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 50.0,
          child: TextFormField(
            controller: ctrPassword,
            focusNode: _passwordFocus,
            textInputAction: TextInputAction.done,
            obscureText: true,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.characters,
            style: TextStyle(color: Colors.white, fontFamily: 'OpenSans'),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'Enter Password',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRememberMeCheckBox() {
    return Container(
      height: 20.0,
      child: Row(
        children: [
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: _rememberMe,
              checkColor: Colors.black,
              activeColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value!;
                  //print('Check Box Value : $_rememberMe');
                });
              },
            ),
          ),
          Text(
            'Remember me',
            style: kLabelStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      /*child: RaisedButton(
        elevation: 5.0,
        //onPressed: () => print('Login Button Pressed'),
        onPressed: () {
          //print('Login Button Pressed');
          //setState(() {
          //  _msg = 'Chk 01';
          //});
          ctrUsername.text = ctrUsername.text.toUpperCase();
          /*final _messaging = FBMessaging.instance;
          _messaging.init();
          _messaging.requestPermission().then((_) async {
            final _token = await _messaging.getToken();
            //print('Token: $_token');
            setState(() {
              _msg = 'Chk 02';
            });
            _getFcmToken(_token);
            setState(() {
              _msg = 'Chk 03';
            });*/
          //});
          _doLogin();
          //setState(() {
          //  _msg = 'Chk 04';
          //});
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'LOGIN',
          style: TextStyle(
            color: Colors.black, //Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),*/
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.pink, // background
          onPrimary: Colors.white, // foreground
          padding: EdgeInsets.all(5.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        ),
        onPressed: () {
          ctrUsername.text = ctrUsername.text.toUpperCase();
          _doLogin();
        },
        child: Text(
          'LOGIN',
          style: TextStyle(
              //fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'OpenSans'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_chkFirst == true) {
      _chkFirst = false;
      getPrefs();
    }
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/p02.jpg'), fit: BoxFit.cover)),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.bottomCenter, colors: [
              Colors.black.withOpacity(.9),
              Colors.black.withOpacity(.6),
              Colors.black.withOpacity(.8),
              Colors.black.withOpacity(.3),
            ]),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                flex: 45,
                child: Container(
                  child: Align(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      backgroundImage: AssetImage('assets/images/logo.jpg'),
                      radius: 90,
                    ),
                    /*child: Image.asset(
                      'assets/images/logo.jpg',
                      scale: 2,
                    ),*/
                  ),
                ),
              ),
              /*Expanded(
                flex: 30,
                child: Text(
                  'BSMART',
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),*/
              Expanded(
                flex: 55,
                child: Container(
                  //color: Colors.blue[500],
                  //padding: EdgeInsets.all(30.0),
                  width: 300.0,
                  //alignment: FractionalOffset.centerLeft,
                  //alignment: Alignment.center,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30.0,
                      ),
                      _buildAccountTF(),
                      SizedBox(
                        height: 20.0,
                      ),
                      _buildPasswordTF(),
                      SizedBox(
                        height: 10.0,
                      ),
                      _buildRememberMeCheckBox(),
                      _buildLoginBtn(),
                      //Text(
                      //  'Message : $_msg',
                      //  style: TextStyle(fontSize: 20.0, color: Colors.white),
                      //),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
