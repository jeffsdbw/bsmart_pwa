import 'package:bsmart_pwa/utilities/menu_widget.dart';
import 'package:flutter/material.dart';

class DevMainScreen extends StatefulWidget {
  const DevMainScreen({Key? key}) : super(key: key);

  @override
  _DevMainScreenState createState() => _DevMainScreenState();
}

class _DevMainScreenState extends State<DevMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          /*SliverAppBar(
            backgroundColor: Colors.white,
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Card(
                  child: Card(
                color: Colors.pinkAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                child: Container(
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('District Manager Application',
                          style: TextStyle(
                              fontSize: 25.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w700)),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text('District Manager Application',
                          style:
                              TextStyle(fontSize: 20.0, color: Colors.white)),
                    ],
                  ),
                ),
              )),
            ),
          ),*/
          SliverAppBar(
            title: Text(
              'Software Development',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.blue,
            expandedHeight: 200.0,
            // 4
            pinned: true,
            elevation: 0,
            // 5
            flexibleSpace: FlexibleSpaceBar(
              /*background: Image.asset(
                'assets/images/wdhead2.jpg',
                fit: BoxFit.fill,
              ),*/
              /*background: Stack(
                children: [
                  Image.asset(
                    'assets/images/wdhead2.jpg',
                    fit: BoxFit.fill,
                  ),
                  Container(
                    child: Center(
                      child: Column(
                        children: [
                          Text('LINE 1'),
                          Text('LINE 2'),
                          Text('LINE 3'),
                          Text('LINE 4'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),*/
              background: Card(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/wdhead2.jpg"),
                      //fit: BoxFit.fitWidth,
                      fit: BoxFit.fill,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 75.0,
                        ),
                        Text(
                          'LINE 000',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          'LINE 2',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          'LINE 3',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          'LINE 4',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverList(
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
          ),
        ],
      ),
      drawer: Menu(),
    );
  }
}
