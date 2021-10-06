import 'package:bsmart_pwa/screens/Dsm/dsm_search_rep.dart';
import 'package:flutter/material.dart';

class SalesRecordMain extends StatefulWidget {
  const SalesRecordMain({Key? key}) : super(key: key);

  @override
  _SalesRecordMainState createState() => _SalesRecordMainState();
}

class _SalesRecordMainState extends State<SalesRecordMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sales Record'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => DsmSearchRep())),
              icon: Icon(Icons.search))
        ],
      ),
      body: Center(
        child: Text('Hell World!'),
      ),
    );
  }
}
