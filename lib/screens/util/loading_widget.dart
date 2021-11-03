import 'package:flutter/material.dart';

Widget loadingWidget() {
  return Center(
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
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
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
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
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
  );
}
