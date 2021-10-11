import 'dart:convert';

import 'package:bsmart_pwa/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class MemberMain extends StatefulWidget {
  const MemberMain({Key? key}) : super(key: key);

  @override
  _MemberMainState createState() => _MemberMainState();
}

class _MemberMainState extends State<MemberMain> {
  late SharedPreferences prefs;
  String server = bwWebserviceUrl;
  String repSeq = '-';
  double dbAr = 0;
  bool arRed = false, yupinRegister = false;
  List<Map<String, dynamic>> _allInfo = [
    {
      "rep_code": "x",
      "rep_name": "x",
      "nick_name": "x",
      "mobile_no": "x",
      "rep_status_code": "x",
      "rep_status_desc": "x",
      "ar_status_code": "x",
      "ar_status_desc": "x",
      "order_status_code": "x",
      "order_status_desc": "x",
      "appt_status_code": "x",
      "appt_status_desc": "x",
      "appt_date": "x",
      "appt_camp": "x",
      "loa": "x",
      "ds_status": "x",
      "yupin_status": "x",
      "yupin_register": "x",
      "point_balance": "x",
      "ar_balance": "x",
      "ar_balance_number": "x",
      "latitude": "x",
      "longitude": "x"
    },
  ];

  Future<Null> getRepInfo(String piRepSeq) async {
    final response = await http.post(
      Uri.parse(server + 'getRepInfo.php?repseq=' + piRepSeq),
    );
    if (response.statusCode == 200) {
      var tagsJson = jsonDecode(response.body)['Rep'];
      _allInfo = (tagsJson != null ? List.from(tagsJson) : null)!;
      dbAr = double.parse(_allInfo[0]['ar_balance_number']);
      if (dbAr >= 200) {
        arRed = true;
      }
      if (_allInfo[0]['yupin_register'] == 'YES') {
        yupinRegister = true;
      }
      setState(() {});
    } else {
      print('Connection Error!');
    }
  }

  Future<Null> getPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      repSeq = (prefs.getString('repSeq') ?? '-');
      getRepInfo(repSeq);
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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    String dispNickName = _allInfo[0]['nick_name'];
    if (dispNickName.isNotEmpty && dispNickName != '-') {
      dispNickName = '(' + dispNickName + ')';
    } else {
      dispNickName = '';
    }
    return Stack(
      children: [
        Container(
          width: screenWidth,
          height: screenHeight,
          child: CustomPaint(
            painter: CurvePainter(),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            width: screenWidth,
            height: screenHeight,
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Center(
                            child: Icon(
                              Icons.account_circle,
                              size: 120,
                              color: Colors.white,
                            ),
                          )),
                      Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _allInfo[0]['rep_code'],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              Text(
                                '${_allInfo[0]['rep_name']} $dispNickName',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              Text(
                                'วันที่แต่งตั้ง ${_allInfo[0]['appt_date']} (${_allInfo[0]['appt_camp']})',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            ],
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Card(
                      elevation: 10,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: SizedBox(
                        width: screenWidth * 0.9,
                        //height: 500,
                        child: Center(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Row(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Text(
                                                'LOA : ' + _allInfo[0]['loa'])),
                                        Expanded(
                                            flex: 1,
                                            child: yupinRegister
                                                ? Text(
                                                    'Yupin',
                                                    style: TextStyle(
                                                        color: Colors.green,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                : Text(''))
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Row(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Text(
                                              'ยอดหนี้ค้างชำระ',
                                              textAlign: TextAlign.left,
                                            )),
                                        Expanded(
                                            flex: 1,
                                            child: Text(
                                              _allInfo[0]['ar_balance'],
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                  color: arRed
                                                      ? Colors.red
                                                      : Colors.green,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            top: 8.0, bottom: 8.0),
                                        color: Color(0xFFFFB266),
                                        child: Column(
                                          children: [
                                            Text('Rep. Status'),
                                            Text(
                                              _allInfo[0]['rep_status_code'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                            Text(
                                                _allInfo[0]['rep_status_desc']),
                                          ],
                                        ),
                                      )),
                                  Expanded(
                                      flex: 1,
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            top: 8.0, bottom: 8.0),
                                        color: Color(0xFFFFFF66),
                                        child: Column(
                                          children: [
                                            Text('AR Status'),
                                            Text(
                                              _allInfo[0]['ar_status_code'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                            Text(_allInfo[0]['ar_status_desc']),
                                          ],
                                        ),
                                      )),
                                ],
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            top: 8.0, bottom: 8.0),
                                        color: Color(0xFFB2FF66),
                                        child: Column(
                                          children: [
                                            Text('Order Status'),
                                            Text(
                                              _allInfo[0]['order_status_code'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                            Text(_allInfo[0]
                                                ['order_status_desc']),
                                          ],
                                        ),
                                      )),
                                  Expanded(
                                      flex: 1,
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            top: 8.0, bottom: 8.0),
                                        color: Color(0xFF66FF66),
                                        child: Column(
                                          children: [
                                            Text('Appt. Status'),
                                            Text(
                                              _allInfo[0]['appt_status_code'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                            Text(_allInfo[0]
                                                ['appt_status_desc']),
                                          ],
                                        ),
                                      )),
                                ],
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              ElevatedButton(
                                child: Text('ข้อมูลใบส่งของ'),
                                onPressed: () {
                                  print('ข้อมูลใบส่งของ');
                                },
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              ElevatedButton.icon(
                                icon: Icon(
                                  Icons.phone,
                                  color: Colors.white,
                                  size: 24.0,
                                ),
                                label: Text(_allInfo[0]['mobile_no']),
                                onPressed: () {
                                  //print('Call Phone');
                                  launch("tel://029170000");
                                  //launch("tel://"+_allInfo[0]['mobile_no']);
                                },
                                style: ElevatedButton.styleFrom(
                                  shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(20.0),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 8.0,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 25.0),
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.pink, // background
                                    onPrimary: Colors.white, // foreground
                                    padding: EdgeInsets.all(5.0),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                  ),
                                  onPressed: () {
                                    print('Hell World!');
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
                              ),
                            ],
                          ),
                        )),
                      )),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = Color(0xFF0080FF); //Colors.green[800];
    paint.style = PaintingStyle.fill; // Change this to fill

    var path = Path();

    path.moveTo(0, size.height * 0.3);
    path.quadraticBezierTo(
        size.width / 2, size.height / 2, size.width, size.height * 0.3);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
