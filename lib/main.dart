import 'package:flutter/material.dart';
import 'package:kpr/pages/main.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Perhitungan KPR',
      theme: new ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MainPage(),
    );
  }
}