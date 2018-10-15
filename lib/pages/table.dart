import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Tables extends StatefulWidget {
  String type;
  

  @override
  _TablesState createState() => _TablesState();
}

class _TablesState extends State<Tables> {
  String title;

  @override
  void initState(){
    super.initState();
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
    ]);

    setState(() {
      switch (widget.type) {
        case 'flat':
          title = 'Tabel Bunga Flat';
          break;
        default:
          title = 'Tabel Bunga Efektif';
      }      
    });
  }

  @override
  dispose(){
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Container(),
    );
  }
}