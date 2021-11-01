import 'dart:convert';
import 'dart:ui';

import 'package:http/http.dart' as http;
import 'package:bsmart_pwa/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReceiptMain extends StatefulWidget {
  const ReceiptMain({Key? key}) : super(key: key);

  @override
  _ReceiptMainState createState() => _ReceiptMainState();
}

class _ReceiptMainState extends State<ReceiptMain> {
  bool checkInvList = false, checkCancel = false;
  late SharedPreferences prefs;
  String server = bwWebserviceUrl;
  String repSeq = '-', campCC = '-', campYYYY = '-', tmpCamp = '-';
  int cnt = 0, chkColor = 0;
  Color dispColor = Colors.grey;
  List<Map<String, dynamic>> _allInfo = [
    {
      "invoice_no": "x",
      "invoice_date": "x",
      "camp_code": "x",
      "order_source": "x",
      "invoice_status": "x",
      "net_sales": "x",
      "tr_fee": "x",
      "order_type": "x",
      "order_status": "x"
    },
  ];

  Future<Null> getInvInfo(String piRepSeq) async {
    final response = await http.post(
      Uri.parse(server + 'getInvoiceHdr.php?repseq=' + piRepSeq),
    );
    if (response.statusCode == 200) {
      var tagsJson = jsonDecode(response.body)['Inv'];
      _allInfo = (tagsJson != null ? List.from(tagsJson) : null)!;
      setState(() {
        checkInvList = true;
      });
    } else {
      print('Connection Error!');
    }
  }

  Future<Null> getPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      repSeq = (prefs.getString('repSeq') ?? '-');
      getInvInfo(repSeq);
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
    Widget invoiceCard(
        String idx,
        String invNo,
        String netSales,
        String invDate,
        String campCode,
        String ordSource,
        String invStatus,
        String trFee,
        String ordType,
        String ordStatus) {
      if (invStatus == 'NORMAL') {
        checkCancel = false;
      } else {
        checkCancel = true;
      }
      if (tmpCamp != campCode) {
        cnt = cnt + 1;
        chkColor = cnt % 5;
        tmpCamp = campCode;
      }
      if (chkColor == 1) {
        dispColor = Color(0xFF0080FF);
      } else if (chkColor == 2) {
        dispColor = Color(0xFF0000FF);
      } else if (chkColor == 3) {
        dispColor = Color(0xFF7F00FF);
      } else if (chkColor == 4) {
        dispColor = Color(0xFFFF00FF);
      } else if (chkColor == 0) {
        dispColor = Color(0xFFFF007F);
      }
      return (Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: ListTile(
          //title: Text(_allInfo[index]['invoice_no']),
          leading: CircleAvatar(
            backgroundColor: dispColor,
            radius: 45.0,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  campCode.substring(0, 2),
                  style: TextStyle(
                      //fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  campCode.substring(2),
                  style: TextStyle(fontSize: 10.0),
                ),
              ],
            ),
          ),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 4,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        //Text('เลขที่ '),
                        checkCancel
                            ? Text(invNo,
                                style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.lineThrough))
                            : Text(
                                invNo,
                                style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                              ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                  Expanded(
                    flex: 4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '฿ ' + netSales,
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 4.0,
              ),
              Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          //Text('รอบจำหน่าย '),
                          Text(
                            invDate,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      )),
                  Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          //Text('วันที่ '),
                          Text(
                            ordSource + ' (' + ordType + ')',
                            style: TextStyle(color: Colors.grey),
                          )
                        ],
                      )),
                ],
              ),
              checkCancel
                  ? Container(
                      width: double.infinity,
                      child: Text(
                        invStatus,
                        style: TextStyle(color: Colors.red),
                        textAlign: TextAlign.left,
                      ),
                    )
                  : Container()
            ],
          ),
          //trailing: Icon(Icons.more_vert),
          onTap: () {
            print(invNo);
          },
        ),
      ));
    }

    return Scaffold(
      body: checkInvList
          ? Column(
              children: [
                Expanded(
                  child: _allInfo.length > 0
                      ? ListView.builder(
                          itemCount: _allInfo.length,
                          itemBuilder: (context, index) => Card(
                            key: ValueKey(_allInfo[index]),
                            child: invoiceCard(
                                _allInfo[index].toString(),
                                _allInfo[index]['invoice_no'],
                                _allInfo[index]['net_sales'],
                                _allInfo[index]['invoice_date'],
                                _allInfo[index]['camp_code'],
                                _allInfo[index]['order_source'],
                                _allInfo[index]['invoice_status'],
                                _allInfo[index]['tr_fee'],
                                _allInfo[index]['order_type'],
                                _allInfo[index]['order_status']),
                            elevation: 8.0,
                            shadowColor: Colors.black,
                          ),
                        )
                      : Center(
                          child: Text(
                            'ไม่พบข้อมูลที่ค้นหา',
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                ),
              ],
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
