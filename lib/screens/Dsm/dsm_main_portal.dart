import 'dart:convert';

import 'package:bsmart_pwa/screens/Dsm/dsm_main_screen.dart';
import 'package:bsmart_pwa/screens/util/loading_widget.dart';
import 'package:bsmart_pwa/utilities/constants.dart';
import 'package:bsmart_pwa/utilities/menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DsmMainPortal extends StatefulWidget {
  const DsmMainPortal({Key? key}) : super(key: key);

  @override
  _DsmMainPortalState createState() => _DsmMainPortalState();
}

class _DsmMainPortalState extends State<DsmMainPortal> {
  String userID = 'x', server = bwWebserviceUrl, dispMgrName = 'x';
  late SharedPreferences prefs;
  bool checkLocList = false, dispName = true, dispNickName = true;
  var _controller = TextEditingController();
  List<Map<String, dynamic>> _allInfo = [
    {
      "rsd_code": "x",
      "rsd_name": "x",
      "rsm_code": "x",
      "rsm_name": "x",
      "loc_code": "x",
      "loc_name": "x",
      "mgr_name": "x",
      "mgr_nick_name": "x",
      "mrg_payplan": "x",
      "mgr_position": "x",
      "active_camp": "x",
      "search_str": "x"
    },
  ];
  List<Map<String, dynamic>> _foundLoc = [];

  Future<Null> getLoc(String piUserID) async {
    final response = await http.post(
      Uri.parse(server + 'getLocByAccount.php?uesr_id=' + piUserID),
    );
    if (response.statusCode == 200) {
      var tagsJson = jsonDecode(response.body)['District'];
      _allInfo = (tagsJson != null ? List.from(tagsJson) : null)!;
      setState(() {
        _foundLoc = _allInfo;
        checkLocList = true;
        if (_allInfo.length == 1) {
          prefs.setString('locCode', _allInfo[0]['loc_code']);
          //prefs.setString('locCode', '0114');
          prefs.setString('locRedirect', 'Y');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => DsmMainScreen()), //SalesRecordMain()),
          );
        } else {
          prefs.setString('locRedirect', 'N');
        }
      });
    } else {
      print('Connection Error!');
    }
  }

  Future<Null> getPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      userID = (prefs.getString('userID') ?? 'Unknow User');
      getLoc(userID);
      //getLoc("NATTAYAS");
    });
  }

  @override
  void initState() {
    getPrefs();
    _foundLoc = _allInfo;
    super.initState();
  }

  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = _allInfo;
    } else {
      results = _allInfo
          .where((user) => user["search_str"]
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }
    // Refresh the UI
    setState(() {
      _foundLoc = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // The search area here
          title: Container(
        width: double.infinity,
        height: 40,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)),
        child: Center(
          child: TextField(
            controller: _controller,
            onChanged: (value) => _runFilter(value),
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    /* Clear the search field */
                    _controller.clear();
                    _runFilter('');
                  },
                ),
                hintText: 'Search...',
                border: InputBorder.none),
          ),
        ),
      )),
      body: checkLocList
          ? Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Expanded(
                    child: _foundLoc.length > 0
                        ? ListView.builder(
                            itemCount: _foundLoc.length,
                            itemBuilder: (context, index) {
                              if (_foundLoc[index]["mgr_name"] != '-') {
                                dispMgrName = _foundLoc[index]["mgr_name"];
                                if (_foundLoc[index]["mgr_nick_name"] != '-') {
                                  dispMgrName = dispMgrName +
                                      ' (' +
                                      _foundLoc[index]["mgr_nick_name"] +
                                      ')';
                                }
                              } else {
                                dispMgrName = '';
                              }
                              return Card(
                                key: ValueKey(_foundLoc[index].toString()),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.blue,
                                      radius: 24.0,
                                      child: Text(
                                        _foundLoc[index]["loc_code"],
                                        style: TextStyle(
                                            //fontWeight: FontWeight.bold,
                                            fontSize: 15.0,
                                            color: Colors.white),
                                      ),
                                    ),
                                    title: Text(_foundLoc[index]['loc_name']),
                                    subtitle: Text(dispMgrName),
                                    trailing: Icon(Icons.more_vert),
                                    onTap: () {
                                      print('Loc Code : ' +
                                          _foundLoc[index]['loc_code']);
                                      prefs.setString('locCode',
                                          _foundLoc[index]['loc_code']);
                                      prefs.setString('locRedirect', 'N');
                                      //Navigator.pushReplacement(
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DsmMainScreen()), //SalesRecordMain()),
                                      );
                                    },
                                  ),
                                ),
                                elevation: 8.0,
                                shadowColor: Colors.black,
                              );
                            })
                        : Center(
                            child: Text(
                              'ไม่พบข้อมูลที่ค้นหา',
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                  ),
                ],
              ),
            )
          : loadingWidget(),
      drawer: Menu(),
    );
  }
}
