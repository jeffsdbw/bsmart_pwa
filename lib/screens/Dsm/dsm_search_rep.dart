import 'dart:convert';
import 'package:bsmart_pwa/screens/Dsm/rep_info_main.dart';
import 'package:bsmart_pwa/screens/util/loading_widget.dart';
//import 'package:bsmart_pwa/screens/Dsm/sales_record_main.dart';
import 'package:bsmart_pwa/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DsmSearchRep extends StatefulWidget {
  const DsmSearchRep({Key? key}) : super(key: key);

  @override
  _DsmSearchRepState createState() => _DsmSearchRepState();
}

String locCode = '';
bool checkRepList = false;

class _DsmSearchRepState extends State<DsmSearchRep> {
  var _controller = TextEditingController();
  String server = bwWebserviceUrl;
  List<Map<String, dynamic>> _allUsers = [
    {
      "seq": "1",
      "code": "001",
      "name": "Andy",
      "nickname": "Nick",
      "status": "AC",
      "search": "Search Text"
    },
    {
      "seq": "2",
      "code": "002",
      "name": "Aragon",
      "nickname": "Nick",
      "status": "AC",
      "search": "Search Text"
    },
    {
      "seq": "3",
      "code": "003",
      "name": "Bob",
      "nickname": "Nick",
      "status": "AC",
      "search": "Search Text"
    },
    {
      "seq": "4",
      "code": "004",
      "name": "Barbara",
      "nickname": "Nick",
      "status": "AC",
      "search": "Search Text"
    },
    {
      "seq": "5",
      "code": "005",
      "name": "Candy",
      "nickname": "Nick",
      "status": "AC",
      "search": "Search Text"
    },
    {
      "seq": "6",
      "code": "006",
      "name": "Colin",
      "nickname": "Nick",
      "status": "AC",
      "search": "Search Text"
    },
    {
      "seq": "7",
      "code": "007",
      "name": "Audra",
      "nickname": "Nick",
      "status": "AC",
      "search": "Search Text"
    },
    {
      "seq": "8",
      "code": "008",
      "name": "Banana",
      "nickname": "Nick",
      "status": "AC",
      "search": "Search Text"
    },
    {
      "seq": "9",
      "code": "009",
      "name": "Caversky",
      "nickname": "Nick",
      "status": "AC",
      "search": "Search Text"
    },
    {
      "seq": "10",
      "code": "010",
      "name": "Becky",
      "nickname": "Nick",
      "status": "AC",
      "search": "Search Text"
    },
  ];

  late SharedPreferences prefs;
  String locCode = '';
  //var modules;

  // This list holds the data for the list view
  List<Map<String, dynamic>> _foundUsers = [];

  Future<Null> getAllUser(String piDistrict) async {
    final response = await http.post(
      Uri.parse(server + 'getAllLocUser.php?district=' + piDistrict),
    );
    if (response.statusCode == 200) {
      //Map<String, dynamic> map = jsonDecode(response.body);
      //_allUsers2 = map[''];
      //String wh = jsonDecode(response.body).toString();
      //print(wh);
      //_allUsers = jsonDecode(response.body).List;

      var tagsJson = jsonDecode(response.body)['User'];
      //List<Map<String, dynamic>> tags = tagsJson != null ? List.from(tagsJson) : null;
      _allUsers = (tagsJson != null ? List.from(tagsJson) : null)!;
      //List<Map<String, dynamic>> _allUsers2 =
      //    (tagsJson != null ? List.from(tagsJson) : null)!;
      //print(_allUsers);
      setState(() {
        checkRepList = true;
        _foundUsers = _allUsers;
      });
    } else {
      print('Connection Error!');
    }
  }

  Future<Null> getPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      locCode = (prefs.getString('locCode') ?? '-');
      getAllUser(locCode);
    });
  }

  @override
  initState() {
    // at the beginning, all users are shown
    getPrefs();
    _foundUsers = _allUsers;
    super.initState();
  }

  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = _allUsers;
    } else {
      results = _allUsers
          .where((user) => user["search"]
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }
    // Refresh the UI
    setState(() {
      _foundUsers = results;
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
      body: checkRepList
          ? Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Expanded(
                    child: _foundUsers.length > 0
                        ? ListView.builder(
                            itemCount: _foundUsers.length,
                            itemBuilder: (context, index) => Card(
                              key: ValueKey(_foundUsers[index]["seq"]),
                              //color: Colors.amberAccent,
                              //margin: EdgeInsets.symmetric(vertical: 4),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  /*leading: Text(
                              _foundUsers[index]["status"],
                              style: TextStyle(fontSize: 24),
                            ),*/
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.blue,
                                    radius: 20.0,
                                    child: Text(
                                      _foundUsers[index]["status"],
                                      style: TextStyle(
                                          //fontWeight: FontWeight.bold,
                                          fontSize: 15.0,
                                          color: Colors.white),
                                    ),
                                  ),
                                  title: Text(_foundUsers[index]['name']),
                                  subtitle: Text(
                                      '${_foundUsers[index]["code"]} (${_foundUsers[index]["nickname"] ?? '-'})'),
                                  trailing: Icon(Icons.more_vert),
                                  onTap: () {
                                    print('Rep. Seq : ' +
                                        _foundUsers[index]['seq']);
                                    prefs.setString(
                                        'repSeq', _foundUsers[index]['seq']);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              RepInfoMain()), //SalesRecordMain()),
                                    );
                                  },
                                ),
                              ),
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
              ),
            )
          : loadingWidget(),
    );
  }
}
