import 'dart:convert';
import 'dart:ui';

import 'package:bsmart_pwa/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class OthersInfoMain extends StatefulWidget {
  const OthersInfoMain({Key? key}) : super(key: key);

  @override
  _OthersInfoMainState createState() => _OthersInfoMainState();
}

class _OthersInfoMainState extends State<OthersInfoMain> {
  late SharedPreferences prefs;
  String server = bwWebserviceUrl;
  String repSeq = '-';
  bool checkProgList = false;
  List<Map<String, dynamic>> _allInfo = [
    {
      "pgm_type": "x",
      "pgm_code": "x",
      "pgm_name": "x",
      "pgm_year": "x",
      "start_camp": "x",
      "end_camp": "x",
      "pgm_remark": "x"
    },
  ];

  Future<Null> getProgramInfo(String piRepSeq) async {
    final response = await http.post(
      Uri.parse(server + 'getRepProgram.php?repseq=' + piRepSeq),
    );
    if (response.statusCode == 200) {
      var tagsJson = jsonDecode(response.body)['Program'];
      _allInfo = (tagsJson != null ? List.from(tagsJson) : null)!;
      //print(_allInfo.toString());
      setState(() {
        checkProgList = true;
      });
    } else {
      print('Connection Error!');
    }
  }

  Future<Null> getPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      repSeq = (prefs.getString('repSeq') ?? '-');
      getProgramInfo(repSeq);
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
      body: checkProgList
          ? _allInfo.length > 0
              ? Padding(
                  padding:
                      const EdgeInsets.only(top: 24.0, left: 16.0, right: 16.0),
                  child: Column(
                    children: [
                      Container(
                        child: Center(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: Text(
                              'โปรแกรมสะสมคะแนนรางวัล',
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
                      Expanded(
                        child: ListView.builder(
                            // the number of items in the list
                            itemCount: _allInfo.length,
                            // display each item of the product list
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 12.0,
                                shadowColor: Colors.black,
                                // In many cases, the key isn't mandatory
                                key: UniqueKey(),
                                /*child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(_allInfo[index]['pgm_code'])),*/
                                child: ListTile(
                                  leading: Container(
                                    //color: Colors.blue,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        _allInfo[index]['pgm_code'],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10.0),
                                          bottomRight: Radius.circular(10.0),
                                          topLeft: Radius.circular(10.0),
                                          bottomLeft: Radius.circular(10.0)),
                                    ),
                                  ),
                                  title: Text(
                                    _allInfo[index]['pgm_name'],
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 24.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Text('ปีที่ : ' +
                                                _allInfo[index]['pgm_year'] +
                                                ' (' +
                                                _allInfo[index]['start_camp'] +
                                                '-' +
                                                _allInfo[index]['end_camp'] +
                                                ')')),
                                        Expanded(
                                            flex: 1,
                                            child: Text(
                                              _allInfo[index]['pgm_type'],
                                              textAlign: TextAlign.right,
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                )
              : Center(
                  child: Text(
                    'ไม่พบข้อมูลรายการสะสมรางวัล',
                    style: TextStyle(fontSize: 24),
                  ),
                )
          : Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          'กำลังโหลดข้อมูล',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 24.0, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 32.0,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          'กรุณารอสักครู่',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 24.0, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 32.0,
                  ),
                  CircularProgressIndicator(),
                ],
              ),
            ),
    );
  }
}
