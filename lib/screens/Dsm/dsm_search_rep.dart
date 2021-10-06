import 'dart:convert';

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

class _DsmSearchRepState extends State<DsmSearchRep> {
  String server = bwWebserviceUrl;
  List<Map<String, dynamic>> _allUsers = [
    {"id": 1, "name": "Andy", "age": 29},
    {"id": 2, "name": "Aragon", "age": 40},
    {"id": 3, "name": "Bob", "age": 5},
    {"id": 4, "name": "Barbara", "age": 35},
    {"id": 5, "name": "Candy", "age": 21},
    {"id": 6, "name": "Colin", "age": 55},
    {"id": 7, "name": "Audra", "age": 30},
    {"id": 8, "name": "Banana", "age": 14},
    {"id": 9, "name": "Caversky", "age": 100},
    {"id": 10, "name": "Becky", "age": 32},
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
          .where((user) =>
              user["name"].toLowerCase().contains(enteredKeyword.toLowerCase()))
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
            /*onChanged: (text) {
              print('First text field: $text');
            },*/
            onChanged: (value) => _runFilter(value),
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    /* Clear the search field */
                  },
                ),
                hintText: 'Search...',
                border: InputBorder.none),
          ),
        ),
      )),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: _foundUsers.length > 0
                  ? ListView.builder(
                      itemCount: _foundUsers.length,
                      itemBuilder: (context, index) => Card(
                        key: ValueKey(_foundUsers[index]["id"]),
                        color: Colors.amberAccent,
                        elevation: 4,
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: ListTile(
                          leading: Text(
                            _foundUsers[index]["id"].toString(),
                            style: TextStyle(fontSize: 24),
                          ),
                          title: Text(_foundUsers[index]['name']),
                          subtitle: Text(
                              '${_foundUsers[index]["age"].toString()} years old'),
                        ),
                      ),
                    )
                  : Text(
                      'No results found',
                      style: TextStyle(fontSize: 24),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
