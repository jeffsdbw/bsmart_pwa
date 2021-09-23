import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bsmart_pwa/utilities/global.dart' as globals;

class Menu extends StatefulWidget {
  Menu({Key? key}) : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  bool isLoading = true;
  late String server;
  late SharedPreferences prefs;
  var modules;

  @override
  void initState() {
    super.initState();
    if (globals.jsModules == null) {
      getPref();
    } else {
      modules = globals.jsModules['results'];
      isLoading = false;
      setState(() {});
    }
  }

  Future<Null> getPref() async {
    prefs = await SharedPreferences.getInstance();
    globals.userID = (prefs.getString('userID') ?? 'No User');
    globals.userName = prefs.getString('userName')!;
    server = (prefs.getString('server') ?? 'Unknow Server');
    setState(() {
      getModules();
    });
  }

  Future<Null> getModules() async {
    //final response = await http
    //    .get(server + 'getModule.php?appid=BSMART&user=' + globals.userID);

    final response = await http.post(
      Uri.parse(server + 'getModule.php?appid=BSMART&user=' + globals.userID),
    );
    if (response.statusCode == 200) {
      globals.jsModules = json.decode(response.body);
      isLoading = false;
      modules = globals.jsModules['results'];

      setState(() {});
    } else {
      print('Connection Error!');
    }
  }

  Future<Null> clearAllPref() async {
    Navigator.of(context).pop();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }

  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Drawer(
            child: Column(
              children: <Widget>[
                UserAccountsDrawerHeader(
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage:
                        AssetImage('assets/images/logo_bsmart_02.jpg'),
                  ),
                  accountName: Text(
                    globals.userID,
                    style: TextStyle(fontSize: 20.0),
                  ),
                  accountEmail: Text(
                    globals.userName,
                    style: TextStyle(fontSize: 20.0),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.pink[400],
                    image: DecorationImage(
                      image: ExactAssetImage('assets/images/wdhead2.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Column(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(
                        Icons.home,
                        size: 35.0,
                      ),
                      title: Text(
                        'Home',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        'Back to Home Screen',
                        style: TextStyle(fontSize: 15.0),
                      ),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, '/main');
                      },
                    ),
                    Divider(),
                  ],
                ),
                Column(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(
                        Icons.account_circle,
                        size: 35.0,
                      ),
                      title: Text(
                        'Profile',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        'Your profile',
                        style: TextStyle(fontSize: 15.0),
                      ),
                      trailing: Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, '/profile');
                      },
                    ),
                    Divider(
                      thickness: 1.0,
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: modules != null ? modules.length : 2,
                      padding: EdgeInsets.only(top: 0.0),
                      itemBuilder: (context, position) {
                        if (position < modules.length) {
                          return Column(
                            children: <Widget>[
                              ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  radius: 20.0,
                                  child: Text(
                                    modules[position]['short'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13.0,
                                        color: Colors.white),
                                  ),
                                ),
                                title: Text(modules[position]['name'],
                                    style: TextStyle(fontSize: 20.0)),
                                subtitle: Text(modules[position]['info'],
                                    style: TextStyle(fontSize: 15.0)),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  Navigator.pushNamed(
                                      context, modules[position]['path']);
                                },
                              ),
                              Divider(
                                thickness: 1.0,
                              ),
                            ],
                          );
                        } else {
                          return Center(
                            child: Text('BSMART'),
                          );
                        }
                      }),
                ),
              ],
            ),
          );
  }
}
