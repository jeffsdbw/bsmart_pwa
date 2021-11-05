import 'dart:convert';
//import 'dart:ui';

import 'package:bsmart_pwa/screens/util/loading_widget.dart';
import 'package:bsmart_pwa/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class InvoiceDetail extends StatefulWidget {
  const InvoiceDetail({Key? key}) : super(key: key);

  @override
  _InvoiceDetailState createState() => _InvoiceDetailState();
}

class _InvoiceDetailState extends State<InvoiceDetail> {
  late SharedPreferences prefs;
  String invYear = ' ', invGroup = ' ', invNo = ' ';
  String server = bwWebserviceUrl;
  bool checkDocList = false, checkCancel = false;

  List<Map<String, dynamic>> _hdrInfo = [
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

  List<Map<String, dynamic>> _dtlInfo = [
    {
      "bill_camp": "x",
      "bill_code": "x",
      "bill_name": "x",
      "bill_brand": "x",
      "bill_price": "x",
      "ship_unit": "x",
      "short_unit": "x",
      "net_sales": "x"
    },
  ];

  Future<Null> getDocInfo(String invYear, String invGroup, String invNo) async {
    final response = await http.post(
      Uri.parse(server +
          'getInvoiceDetail.php?trans_year=' +
          invYear +
          '&trans_group=' +
          invGroup +
          '&trans_no=' +
          invNo),
    );
    if (response.statusCode == 200) {
      var tagsJson = jsonDecode(response.body)['Invoice'];
      var jsonHdrValue = tagsJson['Header'];
      var jsonDtlValue = tagsJson['Detail'];
      //print(tagsJson.toString());
      //print('---------------------------------------------------------------');
      //print(jsonHdrValue.toString());
      //print('---------------------------------------------------------------');
      //print(jsonDtlValue.toString());
      _hdrInfo = (jsonHdrValue != null ? List.from(jsonHdrValue) : null)!;
      //tagsJson = jsonDecode(response.body)['Detail'];
      _dtlInfo = (jsonDtlValue != null ? List.from(jsonDtlValue) : null)!;
      if (_hdrInfo[0]['invoice_status'] != 'NORMAL') {
        checkCancel = true;
      }
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
      invYear = (prefs.getString('invYear') ?? '-');
      invGroup = (prefs.getString('invGroup') ?? '-');
      invNo = (prefs.getString('invNo') ?? '-');
      getDocInfo(invYear, invGroup, invNo);
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
    Widget header() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: double.infinity,
          height: 200.0,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Center(
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 56.0,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                _hdrInfo[0]['camp_code'].substring(0, 2),
                                style: TextStyle(
                                    //fontWeight: FontWeight.bold,
                                    fontSize: 40.0,
                                    color: Colors.blue[800],
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                _hdrInfo[0]['camp_code'].substring(2),
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.blue[800],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              child: Text(
                                _hdrInfo[0]['invoice_no'],
                                style: TextStyle(
                                  color:
                                      checkCancel ? Colors.red : Colors.white,
                                  fontSize: 40.0,
                                  fontWeight: FontWeight.bold,
                                  decoration: checkCancel
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              child: Text(
                                _hdrInfo[0]['invoice_status'],
                                style: TextStyle(
                                    color:
                                        checkCancel ? Colors.red : Colors.white,
                                    fontSize: 24.0),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
              Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Container(
                        width: double.infinity,
                        height: 50.0,
                        //color: Colors.orange,
                        child: Center(
                          child: Text(
                            _hdrInfo[0]['invoice_date'],
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0),
                          ),
                        ),
                      )),
                  Expanded(
                      flex: 2,
                      child: Container(
                        width: double.infinity,
                        height: 50.0,
                        //color: Colors.amber,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Text(
                            '฿ ' + _hdrInfo[0]['net_sales'],
                            style:
                                TextStyle(color: Colors.white, fontSize: 24.0),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      )),
                ],
              ),
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
                topLeft: Radius.circular(20.0),
                bottomLeft: Radius.circular(20.0)),
            gradient:
                LinearGradient(colors: [Color(0xFF66B2FF), Color(0xFF0066CC)]),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
        ),
      );
    }

    Widget detail() {
      return Expanded(
        child: _dtlInfo.length > 0
            ? ListView.builder(
                itemCount: _dtlInfo.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Card(
                    key: ValueKey(_dtlInfo[index].toString()),
                    child: ListTile(
                      leading: Container(
                          //color: Colors.blue,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              _dtlInfo[index]['bill_code'],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0),
                                topLeft: Radius.circular(10.0),
                                bottomLeft: Radius.circular(10.0)),
                          )),
                      title: Text(
                        _dtlInfo[index]['bill_name'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: Text(
                                  (_dtlInfo[index]['short_unit'] != '0'
                                      ? 'Short ' +
                                          _dtlInfo[index]['short_unit'] +
                                          ' ชิ้น' +
                                          (_dtlInfo[index]['ship_unit'] == '0'
                                              ? ''
                                              : 'จัดสินค้า ' +
                                                  _dtlInfo[index]['ship_unit'] +
                                                  ' ชิ้น')
                                      : _dtlInfo[index]['ship_unit'] + ' ชิ้น'),
                                )),
                            Expanded(
                                flex: 1,
                                child: Text(
                                  '฿ ' + _dtlInfo[index]['net_sales'],
                                  textAlign: TextAlign.right,
                                )),
                          ],
                        ),
                      ),
                    ),
                    elevation: 8.0,
                    shadowColor: Colors.black,
                  ),
                ),
              )
            : Center(
                child: Text(
                  'ไม่พบข้อมูลที่ค้นหา',
                  style: TextStyle(fontSize: 24),
                ),
              ),
      );

      /*return Expanded(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: 200,
              height: 200,
              color: Colors.amber,
            ),
            Container(
              width: 200,
              height: 200,
              color: Colors.orange,
            ),
            Container(
              width: 200,
              height: 200,
              color: Colors.red,
            ),
            Container(
              width: 200,
              height: 200,
              color: Colors.green,
            ),
          ],
        ),
      ));*/
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('รายละเอียดใบส่งของ'),
        centerTitle: true,
      ),
      /*body: Center(
        child: Text(
          'Invoice Detail : ' + invNo,
          style: TextStyle(
              color: Colors.blue, fontSize: 30.0, fontWeight: FontWeight.bold),
        ),
      ),*/
      body: checkDocList
          ? Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                header(),
                detail(),
                //Text(_hdrInfo[0]['invoice_no']),
                //Text(_dtlInfo[0]['bill_code']),
              ],
            )
          : loadingWidget(),
    );
  }
}
