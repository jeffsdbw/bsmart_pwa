import 'dart:convert';
import 'dart:ui';

import 'package:bsmart_pwa/screens/util/loading_widget.dart';
import 'package:http/http.dart' as http;
import 'package:bsmart_pwa/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressMain extends StatefulWidget {
  const AddressMain({Key? key}) : super(key: key);

  @override
  _AddressMainState createState() => _AddressMainState();
}

class _AddressMainState extends State<AddressMain> {
  bool checkDocList = false,
      checkCancel = false,
      checkSignPos = false,
      checkShowMore = false;
  late SharedPreferences prefs;
  String server = bwWebserviceUrl;
  String repSeq = '-', campCC = '-', campYYYY = '-', tmpCamp = '-';
  int cnt = 0, chkColor = 0;
  Color dispColor = Colors.grey;
  List<Map<String, dynamic>> _allInfo = [
    {"delivery": "x", "register": "x", "del_tel": "x", "reg_tel": "x"},
  ];

  Future<Null> getAddressInfo(String piRepSeq) async {
    final response = await http.post(
      Uri.parse(server + 'getRepAddress.php?repseq=' + piRepSeq),
    );
    if (response.statusCode == 200) {
      var tagsJson = jsonDecode(response.body)['Address'];
      _allInfo = (tagsJson != null ? List.from(tagsJson) : null)!;
      setState(() {
        checkDocList = true;
      });
    } else {
      print('Connection Error!');
    }
  }

  Future<Null> getPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      repSeq = (prefs.getString('repSeq') ?? '-');
      getAddressInfo(repSeq);
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
    return Scaffold(
      body: checkDocList
          ? Center(
              child: Column(
                children: [
                  Card(
                    elevation: 16.0,
                    color: Colors.blue,
                    shadowColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white70, width: 1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          child: Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: Text(
                                '????????????????????????????????????????????????',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20.0),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20.0),
                              //bottomRight: Radius.circular(20.0),
                              topLeft: Radius.circular(20.0),
                              //bottomLeft: Radius.circular(20.0)
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 8.0,
                                  bottom: 24.0,
                                  left: 8.0,
                                  right: 8.0),
                              /*child: Text(
                                _allInfo[0]['delivery'],
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16.0),
                              ),*/
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _allInfo[0]['delivery'],
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.0),
                                      ),
                                      SizedBox(
                                        height: 16.0,
                                        width: 8.0,
                                      ),
                                      Text(
                                        '???????????????????????? : ' + _allInfo[0]['del_tel'],
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.0),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                //topRight: Radius.circular(20.0),
                                bottomRight: Radius.circular(20.0),
                                //topLeft: Radius.circular(20.0),
                                bottomLeft: Radius.circular(20.0)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Card(
                    elevation: 16.0,
                    color: Colors.blue,
                    shadowColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white70, width: 1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          child: Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: Text(
                                '???????????????????????????????????????????????????????????????',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20.0),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20.0),
                              //bottomRight: Radius.circular(20.0),
                              topLeft: Radius.circular(20.0),
                              //bottomLeft: Radius.circular(20.0)
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 8.0,
                                  bottom: 24.0,
                                  left: 8.0,
                                  right: 8.0),
                              /*child: Text(
                                _allInfo[0]['delivery'],
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16.0),
                              ),*/
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _allInfo[0]['register'],
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.0),
                                      ),
                                      SizedBox(
                                        height: 16.0,
                                        width: 8.0,
                                      ),
                                      Text(
                                        '???????????????????????? : ' + _allInfo[0]['reg_tel'],
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.0),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                //topRight: Radius.circular(20.0),
                                bottomRight: Radius.circular(20.0),
                                //topLeft: Radius.circular(20.0),
                                bottomLeft: Radius.circular(20.0)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : loadingWidget(),
    );
  }
}
