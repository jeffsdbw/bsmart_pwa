import 'dart:convert';
import 'dart:async';
import 'dart:ui';
import 'package:bsmart_pwa/utilities/constants.dart';
import 'package:bsmart_pwa/utilities/menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  final jsModules;
  ProfileScreen({Key? key, this.jsModules}) : super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var jsUserinfo;

  bool isLoading = true, isLoadingI = true, chkUserImg = false;
  String userID = '', userName = '', token = '', userImg = '', versionCode = '';
  String userAccount = '',
      userShortName = '',
      userDept = '',
      userEmail = '',
      userDeptCode = '';

  Future<Null> clearAllPref() async {
    Navigator.of(context).pop();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }

  Future<Null> getUserInfo() async {
    //PackageInfo packageInfo = await PackageInfo.fromPlatform();
    //versionCode = packageInfo.buildNumber;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String server = bwWebserviceUrl;
    userID = (prefs.getString('userID') ?? 'Unknow User');
    //userName = (prefs.getString('userName') ?? 'Unknow Name');
    //final response =
    //    await http.get(server + 'getUserInfo.php?appid=BSMART&user=' + userID);

    final response = await http.post(
      Uri.parse(server + 'getUserInfo.php?appid=BSMART&user=' + userID),
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      isLoadingI = false;
      jsUserinfo = jsonResponse['results'];
      //print('JSON Profile:' + jsUserinfo.toString());
      userImg = jsUserinfo['image'];
      if (userImg.isEmpty || userImg == '') {
        chkUserImg = false;
      } else {
        chkUserImg = true;
      }
      userAccount = jsUserinfo['account'];
      userName = jsUserinfo['name'];
      userShortName = jsUserinfo['short'];
      userDept = jsUserinfo['dept'];
      userEmail = jsUserinfo['email'];
      userDeptCode = jsUserinfo['dept_code'];
      setState(() {});
    } else {}
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PROFILE',
        ),
        centerTitle: true,
        /*actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              onPressed: () {
                exit(0);
              }),
        ],*/
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 25,
                child: Container(
                  padding: EdgeInsets.all(2.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.emoji_emotions_outlined,
                        size: 120.0,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 60,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'User Account',
                                style: TextStyle(color: Colors.lightBlue),
                              ),
                              Text(
                                userAccount,
                                style: TextStyle(
                                  fontSize: 17.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'User Name',
                                style: TextStyle(color: Colors.lightBlue),
                              ),
                              Text(
                                userName,
                                style: TextStyle(
                                  fontSize: 17.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        /*Container(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Short Name',
                            style: TextStyle(color: Colors.lightBlue),
                          ),
                          Text(
                            userShortName,
                            style: TextStyle(
                              fontSize: 20.0,
                            ),
                          ),
                        ],
                      ),
                    ),*/
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Email',
                                style: TextStyle(color: Colors.lightBlue),
                              ),
                              Text(
                                userEmail,
                                style: TextStyle(
                                  fontSize: 17.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Department Name',
                                style: TextStyle(color: Colors.lightBlue),
                              ),
                              Text(
                                userDept,
                                style: TextStyle(
                                  fontSize: 17.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Department Code',
                                style: TextStyle(color: Colors.lightBlue),
                              ),
                              Text(
                                userDeptCode,
                                style: TextStyle(
                                  fontSize: 17.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 15,
                child: Container(
                  alignment: Alignment.center,
                  /*
                  child: RaisedButton.icon(
                    onPressed: () {
                      clearAllPref();
                      Navigator.of(context).pop();
                      Navigator.pushNamed(context, '/login');
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    label: Text(
                      'Logout your account',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17.0,
                      ),
                    ),
                    icon: Icon(
                      Icons.exit_to_app,
                      color: Colors.white,
                    ),
                    textColor: Colors.white,
                    splashColor: Colors.red,
                    color: Colors.lightBlue,
                    padding: EdgeInsets.all(16.0),
                  ),
                  */
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.pink, // background
                      onPrimary: Colors.white, // foreground
                      padding: EdgeInsets.all(10.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                    ),
                    onPressed: () {
                      clearAllPref();
                      Navigator.of(context).pop();
                      Navigator.pushNamed(context, '/login');
                    },
                    child: Text(
                      'Logout your account',
                      style: TextStyle(
                          //fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'OpenSans'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      /*body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              color: Colors.white,
              child: jsUserinfo.length == 0
                  ? Center(child: CircularProgressIndicator())
                  : Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 24.0, bottom: 24.0),
                            child: chkUserImg
                                ? CircleAvatar(
                                    backgroundColor: Colors.white,
                                    backgroundImage: NetworkImage(userImg),
                                    radius: 65.0,
                                  )
                                : Icon(
                                    Icons.account_circle,
                                    size: 170.0,
                                    color: Colors.grey,
                                  ),
                          ),
                          _rowProfileData('Account', jsUserinfo['account']),
                          _rowProfileData('Name', jsUserinfo['name']),
                          //_rowProfileData('Short Name', jsUserinfo['short']),
                          _rowProfileData('Dept.', jsUserinfo['dept']),
                          _rowProfileData('Email', jsUserinfo['email']),
                          _rowProfileData('Login', jsUserinfo['lastlogin']),
                          _rowProfileData('Session', jsUserinfo['lastsession']),
                          /*new Padding(
                            padding:
                                const EdgeInsets.only(top: 24.0, bottom: 24.0),
                            child: new Text(
                              "Version : " + versionCode,
                            ),
                          ),*/
                        ],
                      ),
                    ),
            ),*/
      drawer: Menu(),
    );
  }

  /*
  Widget _rowProfileData(String textTitle, String textData) {
    return new Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        new Icon(
          Icons.place,
          color: Colors.white,
          size: 16.0,
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Text(
              textTitle,
              textAlign: TextAlign.right,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Text(
            textData,
            textAlign: TextAlign.left,
            style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }*/
}
