import 'package:flutter/material.dart';

final kHintTextStyle = TextStyle(
  color: Colors.white54,
  fontFamily: 'OpenSans',
);

final kLabelStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final kBoxDecorationStyle = BoxDecoration(
  //color: Color(0xFF6CA8F1),
  color: Colors.white24,
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);

const kBackgroundColor = Color(0xFFF1EFF1);
const kPrimaryColor = Color(0xFF42A5F5); //Color(0xFF035AA6);
const kSecondaryColor = Colors.orange;
const kTextHeader = Colors.white;
const kTextColor = Colors.green;
const kTextLightColor = Color(0xFF747474);

const kDefaultPadding = 20.0;

const kDefaultShadow = BoxShadow(
  offset: Offset(0, 15),
  blurRadius: 27,
  color: Colors.black12,
);

final String bwWebserviceUrl = 'https://bsmartapp.mistine.co.th/service/';
final String fsUrl1 = 'https://supplier.mistine.co.th/ETL_FILE/Picture/';
final String fsUrl2 = '-1.gif';
final String itemUrl1 =
    'https://supplier.mistine.co.th/sourcing/content/images/product/';
