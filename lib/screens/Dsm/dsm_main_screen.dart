import 'dart:convert';

import 'package:bsmart_pwa/utilities/menu_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bsmart_pwa/utilities/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class DsmMainScreen extends StatefulWidget {
  const DsmMainScreen({Key? key}) : super(key: key);

  @override
  _DsmMainScreenState createState() => _DsmMainScreenState();
}

class _DsmMainScreenState extends State<DsmMainScreen> {
  bool getData = false;
  String resultCode = "X",
      resultDesc = "X",
      districtCode = "X",
      districtName = "XXXXX",
      managerName = "X",
      mgrShortName = "X",
      empId = "X",
      mgrPayplan = "X",
      mgrPosition = "X",
      activateCamp = "X",
      rsdCode = "X",
      rsdName = "X",
      rsmCode = "X",
      rsmName = "X",
      userID = "X",
      server = bwWebserviceUrl;

  Future<Null> getUserInfo() async {
    if (getData == false) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      userID = (prefs.getString('userID') ?? 'Unknow User');

      final response = await http.post(
        Uri.parse(bwWebserviceUrl + 'getDsmMenu.php?user=' + userID),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> map = jsonDecode(response.body);
        resultCode = map['results']['result_code'];
        resultDesc = map['results']['result_desc'];
        districtCode = map['results']['district_code'];
        districtName = map['results']['district_name'];
        managerName = map['results']['manager_name'];
        mgrShortName = map['results']['mgr_short_name'];
        empId = map['results']['emp_id'];
        mgrPayplan = map['results']['mgr_payplan'];
        mgrPosition = map['results']['mgr_position'];
        activateCamp = map['results']['activate_camp'];
        rsdCode = map['results']['rsd_code'];
        rsdName = map['results']['rsd_name'];
        rsmCode = map['results']['rsm_code'];
        rsmName = map['results']['rsm_name'];
        prefs.setString('locCode', districtCode);
        setState(() {});
      }
      getData = true;
    }
  }

/*
  Future<Null> getDistrictInfo() async {
    final response = await http.post(
      Uri.parse(bwWebserviceUrl +
          'getDsmMenu.php?user=' +
          userID),
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> map = jsonDecode(response.body);
      String status = map['results']['status'];
  }
*/
/*
  @override
  void initState() {
    super.initState();
    getUserInfo();
  }
*/

  Card buildCard(String cTitle, String cSubTitle, String routePath) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
            leading: Icon(Icons.list),
            title: Text(
              cTitle,
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(cSubTitle),
            onTap: () {
              //print(cTitle);
              Navigator.pushNamed(context, routePath);
            }),
      ),
      elevation: 8.0,
      shadowColor: Colors.black,
    );
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    //getUserInfo();
    //double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: screenHeight * 0.3,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text('District Sales Manager'),
                centerTitle: true,
                background: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(
                        'assets/images/bw2.jpg',
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, bottom: 8.0, left: 16.0, right: 8.0),
                    child: Center(
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  alignment: Alignment(0.0, -0.5),
                                  width: screenHeight * 0.15,
                                  height: screenHeight * 0.15,
                                  child: Icon(
                                    Icons.account_circle,
                                    size: 100.0,
                                    color: Colors.white,
                                  ),
                                  /*decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image:
                                          AssetImage('assets/images/logo.jpg'),
                                    ),
                                  ),*/
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(districtCode,
                                              style: TextStyle(
                                                  color: Colors.amberAccent,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 30.0)),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                        width: 5.0,
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            districtName,
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                        width: 5.0,
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            '$managerName($mgrShortName)',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          )
                                        ],
                                      ),
                                      /*SizedBox(
                                        height: 5.0,
                                        width: 5.0,
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            '$rsmName - $rsmCode ($rsdCode)',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          )
                                        ],
                                      ),*/
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                /*
                background: Image.asset(
                  'assets/images/bw.jpg',
                  fit: BoxFit.cover,
                ),
                */
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  buildCard('ข้อมูลสมาชิก', 'รายชื่อและรายละเอียดของสมาชิก',
                      '/dsmSearchRep'),
                  buildCard(
                      'District Campaign Sales',
                      'ข้อมูลสรุปผลงานต่างๆ ตามรอบจำหน่าย ของผู้จัดการเขต',
                      '/dsmEmptyPage'),
                  /*buildCard(
                      'เมนูที่ 3', 'รายละเอียดรของเมนูที่ 3', '/dsmEmptyPage'),
                  buildCard(
                      'เมนูที่ 4', 'รายละเอียดรของเมนูที่ 4', '/dsmEmptyPage'),
                  buildCard(
                      'เมนูที่ 5', 'รายละเอียดรของเมนูที่ 5', '/dsmEmptyPage'),
                  buildCard(
                      'เมนูที่ 6', 'รายละเอียดรของเมนูที่ 6', '/dsmEmptyPage'),
                  buildCard(
                      'เมนูที่ 7', 'รายละเอียดรของเมนูที่ 7', '/dsmEmptyPage'),
                  buildCard(
                      'เมนูที่ 8', 'รายละเอียดรของเมนูที่ 8', '/dsmEmptyPage'),
                  buildCard(
                      'เมนูที่ 9', 'รายละเอียดรของเมนูที่ 9', '/dsmEmptyPage'),
                  buildCard('เมนูที่ 10', 'รายละเอียดรของเมนูที่ 10',
                      '/dsmEmptyPage'),
                  buildCard('เมนูที่ 11', 'รายละเอียดรของเมนูที่ 11',
                      '/dsmEmptyPage'),
                  buildCard('เมนูที่ 12', 'รายละเอียดรของเมนูที่ 12',
                      '/dsmEmptyPage'),*/
                ],
              ),
            ),
            /*SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return Card(
                    margin: EdgeInsets.all(15),
                    child: Container(
                      color: Colors.blue[100 * (index % 9 + 1)],
                      height: 80,
                      alignment: Alignment.center,
                      child: Text(
                        "Item $index",
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                  );
                },
                childCount: 1000, // 1000 list items
              ),
            ),*/
            /*SliverFillRemaining(
              child: Column(
                children: [
                  buildCard('ข้อมูลสมาชิก', 'รายชื่อและรายละเอียดของสมาชิก',
                      '/dsmSearchRep'),
                  buildCard(
                      'District Campaign Sales',
                      'ข้อมูลสรุปผลงานต่างๆ ตามรอบจำหน่าย ของผู้จัดการเขต',
                      '/salesRecord'),
                  buildCard(
                      'เมนูที่ 3', 'รายละเอียดรของเมนูที่ 3', '/salesRecord'),
                  buildCard(
                      'เมนูที่ 4', 'รายละเอียดรของเมนูที่ 4', '/salesRecord'),
                  buildCard(
                      'เมนูที่ 5', 'รายละเอียดรของเมนูที่ 5', '/salesRecord'),
                  buildCard(
                      'เมนูที่ 6', 'รายละเอียดรของเมนูที่ 6', '/salesRecord'),
                  buildCard(
                      'เมนูที่ 7', 'รายละเอียดรของเมนูที่ 7', '/salesRecord'),
                  buildCard(
                      'เมนูที่ 8', 'รายละเอียดรของเมนูที่ 8', '/salesRecord'),
                  buildCard(
                      'เมนูที่ 9', 'รายละเอียดรของเมนูที่ 9', '/salesRecord'),
                ],
              ),
            ),*/
          ],
        ),
      ),
      drawer: Menu(),
    );
    /*return Scaffold(
      backgroundColor: Color(0xffF8F8FA),
      appBar: AppBar(
        title: Text('District Manager Application'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.blue[600],
            height: screenHeight * 0.25,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        height: screenHeight * 0.15,
                        width: screenHeight * 0.15,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage('assets/images/logo.jpg'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      drawer: Menu(),
    );*/
  }
}
