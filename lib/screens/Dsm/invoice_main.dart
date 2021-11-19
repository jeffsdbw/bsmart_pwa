import 'dart:convert';
import 'dart:ui';

import 'package:bsmart_pwa/screens/Dsm/invoice_detail.dart';
import 'package:bsmart_pwa/screens/util/loading_widget.dart';
import 'package:http/http.dart' as http;
import 'package:bsmart_pwa/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InvoiceMain extends StatefulWidget {
  const InvoiceMain({Key? key}) : super(key: key);

  @override
  _InvoiceMainState createState() => _InvoiceMainState();
}

class _InvoiceMainState extends State<InvoiceMain> {
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
    {
      "doc_no": "x",
      "doc_type": "x",
      "doc_date": "x",
      "doc_amt": "x",
      "create_date": "x",
      "nature_sign": "x",
      "doc_status": "x",
      "camp_code": "x",
      "qry": "x",
      "trans_year": "x",
      "trans_group": "x",
      "cnt_dtl": "x",
      "seq": "x",
    },
  ];

  Future<Null> getDocInfo(String piRepSeq) async {
    final response = await http.post(
      Uri.parse(server + 'getRepTrans.php?repseq=' + piRepSeq),
    );
    if (response.statusCode == 200) {
      var tagsJson = jsonDecode(response.body)['Inv'];
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
      getDocInfo(repSeq);
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
        String docNo,
        String docType,
        String docDate,
        String docAmt,
        String createDate,
        String natureSign,
        String docStatus,
        String campCode,
        String qry,
        String transYear,
        String transGroup,
        String cntDtl,
        String seq) {
      if (docStatus == 'NORMAL') {
        checkCancel = false;
      } else {
        checkCancel = true;
      }
      if (checkCancel == true && qry == '1') {
        checkShowMore = true;
      } else {
        checkShowMore = false;
      }

      if (natureSign == '+') {
        checkSignPos = true;
      } else {
        checkSignPos = false;
      }
      /*if (tmpCamp != campCode) {
        cnt = cnt + 1;
        chkColor = cnt % 5;
        tmpCamp = campCode;
      }*/
      chkColor = int.parse(seq) % 5;
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
                  campCode.substring(3),
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
                            ? Text(docType,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  decoration: checkShowMore
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                ))
                            : Text(
                                docType,
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
                          natureSign + ' ' + docAmt,
                          style: TextStyle(
                            color: checkSignPos ? Colors.red : Colors.green,
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
                            docDate,
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
                            docNo,
                            style: TextStyle(color: Colors.grey),
                          )
                        ],
                      )),
                ],
              ),
              checkShowMore
                  ? Container(
                      width: double.infinity,
                      child: Text(
                        docStatus,
                        style: TextStyle(color: Colors.red),
                        textAlign: TextAlign.left,
                      ),
                    )
                  : Container()
            ],
          ),
          //trailing: Icon(Icons.more_vert),
          onTap: () {
            print('invYear:' +
                transYear +
                ', invGroup:' +
                transGroup +
                ', invNo:' +
                docNo);
            if (transGroup == '11') {
              if (int.parse(cntDtl) == 0) {
                showDialog<Null>(
                    context: context,
                    builder: (BuildContext context) {
                      return SimpleDialog(
                        title: const Text(
                          'ไม่พบข้อมูลรายละเอียด!!!',
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
                prefs.setString('invYear', transYear);
                prefs.setString('invGroup', transGroup);
                prefs.setString('invNo', docNo);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          InvoiceDetail()), //SalesRecordMain()),
                );
              }
            }
          },
        ),
      ));
    }

    return Scaffold(
      body: checkDocList
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
                                _allInfo[index]['doc_no'],
                                _allInfo[index]['doc_type'],
                                _allInfo[index]['doc_date'],
                                _allInfo[index]['doc_amt'],
                                _allInfo[index]['create_date'],
                                _allInfo[index]['nature_sign'],
                                _allInfo[index]['doc_status'],
                                _allInfo[index]['camp_code'],
                                _allInfo[index]['qry'],
                                _allInfo[index]['trans_year'],
                                _allInfo[index]['trans_group'],
                                _allInfo[index]['cnt_dtl'],
                                _allInfo[index]['seq']),
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
          : loadingWidget(),
    );
  }
}
