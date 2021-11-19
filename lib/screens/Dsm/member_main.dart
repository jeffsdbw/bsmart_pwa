import 'dart:convert';
import 'dart:ui';

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
      "yupin_segment": "x",
      "mistine_segment": "x",
      "friday_segment": "x",
      "faris_segment": "x",
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

    // ignore: non_constant_identifier_names
    Widget header() {
      return Container(
        padding: EdgeInsets.only(top: 8.0),
        width: screenWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                    flex: 2,
                    child: Container(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.account_circle,
                        size: 120,
                        color: Colors.white,
                      ),
                    )),
                Expanded(
                    flex: 4,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _allInfo[0]['rep_code'],
                            style: TextStyle(
                                fontSize: 32.0,
                                color: Colors.amber,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Text(
                            '${_allInfo[0]['rep_name']} $dispNickName',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ],
        ),
      );
    }

    Widget detail() {
      return Expanded(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Card(
            margin: EdgeInsets.only(left: 24.0, right: 24.0),
            elevation: 10,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                                color: arRed ? Colors.red : Colors.green,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  Divider(
                    thickness: 2.0,
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          flex: 1,
                          child: Text(
                            'วันที่แต่งตั้ง',
                            textAlign: TextAlign.left,
                          )),
                      Expanded(
                          flex: 1,
                          child: Text(
                            _allInfo[0]['appt_date'] +
                                ' (' +
                                _allInfo[0]['appt_camp'] +
                                ')',
                            textAlign: TextAlign.right,
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
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
                                Text(_allInfo[0]['rep_status_desc']),
                              ],
                            ),
                          )),
                      Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
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
                            padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
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
                                Text(_allInfo[0]['order_status_desc']),
                              ],
                            ),
                          )),
                      Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
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
                                Text(_allInfo[0]['appt_status_desc']),
                              ],
                            ),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  Card(
                    elevation: 4.0,
                    shadowColor: Colors.black,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue,
                        radius: 20.0,
                        child: Icon(
                          Icons.call,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        _allInfo[0]['mobile_no'],
                        style: TextStyle(
                            fontSize: 24.0,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                      onTap: () {
                        launch("tel://029170000");
                        //launch("tel://"+_allInfo[0]['mobile_no']);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  Card(
                    elevation: 4.0,
                    shadowColor: Colors.black,
                    child: yupinRegister
                        ? ListTile(
                            leading: Image.asset(
                              'assets/images/yupin_logo.png',
                              //scale: 1.5,
                            ),
                            /*title: Text(
                              'สถานะยุพิน : ' +
                                  _allInfo[0]['yupin_status'] +
                                  ', Segment : ' +
                                  _allInfo[0]['yupin_segment'],
                              textAlign: TextAlign.center,
                            ),*/
                            title: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: [
                                      Text(
                                        'Status',
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          _allInfo[0]['yupin_status'],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10.0),
                                              bottomRight:
                                                  Radius.circular(10.0),
                                              topLeft: Radius.circular(10.0),
                                              bottomLeft:
                                                  Radius.circular(10.0)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  /*child: Container(
                                      width: 200.0,
                                      //padding: EdgeInsets.all(8.0),
                                      //color: Colors.blue,
                                      child: Column(
                                        children: [
                                          Text('Status'),
                                          Text(
                                            _allInfo[0]['yupin_status'],
                                            style: TextStyle(
                                                color: Colors.white,
                                                //fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10.0),
                                            bottomRight: Radius.circular(10.0),
                                            topLeft: Radius.circular(10.0),
                                            bottomLeft: Radius.circular(10.0)),
                                      ),
                                    )*/
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: [
                                      Text(
                                        'Segment',
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          _allInfo[0]['yupin_segment'],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.blue,
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10.0),
                                              bottomRight:
                                                  Radius.circular(10.0),
                                              topLeft: Radius.circular(10.0),
                                              bottomLeft:
                                                  Radius.circular(10.0)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Text(' '),
                  ),
                  /*Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue,
                            radius: 20.0,
                            child: Icon(
                              Icons.call,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(_allInfo[0]['mobile_no']),
                          onTap: () {
                            launch("tel://029170000");
                            //launch("tel://"+_allInfo[0]['mobile_no']);
                          },
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: yupinRegister
                            ? ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 20.0,
                                  child: Image.asset(
                                      'assets/images/yupin_logo.png'),
                                ),
                                title: Column(
                                  children: [
                                    Text('สถานะยุพิน : ' +
                                        _allInfo[0]['yupin_status']),
                                    Text('Segment : ' +
                                        _allInfo[0]['yupin_segment']),
                                  ],
                                ),
                              )
                            : Text(' '),
                      ),
                    ],
                  ),*/
                  SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                            color: Color(0xFF99CCFF),
                            child: Column(
                              children: [
                                Text('Rep. Segment'),
                                Text(
                                  _allInfo[0]['ds_status'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ],
                            ),
                          )),
                      Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                            color: Color(0xFF9999FF),
                            child: Column(
                              children: [
                                Text('Mistine Segment'),
                                Text(
                                  _allInfo[0]['mistine_segment'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
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
                            padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                            color: Color(0xFFCC99FF),
                            child: Column(
                              children: [
                                Text('Friday Segment'),
                                Text(
                                  _allInfo[0]['friday_segment'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ],
                            ),
                          )),
                      Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                            color: Color(0xFFFF99FF),
                            child: Column(
                              children: [
                                Text('Faris Segment'),
                                Text(
                                  _allInfo[0]['faris_segment'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
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
          body: Column(
            children: [
              header(),
              SizedBox(
                height: 16.0,
              ),
              detail(),
            ],
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
