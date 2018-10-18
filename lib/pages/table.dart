import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Tables extends StatefulWidget {
  String type;
  Tables({Key key, this.type}) : super(key: key);

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
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(bottom: 5.0),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(width: 1.0))
              ),
              child: Row(
                children: <Widget>[
                  Expanded(child: Text('Bulan')),
                  Expanded(child: Text('Pokok')),
                  Expanded(child: Text('Bunga')),
                  Expanded(child: Text('Total Cicilan'))
                ],
              ),
            ),
            Expanded(
                          child: Container(
                // height: 250.0,
                child: ListView.builder(
                  itemCount: 30,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      padding: EdgeInsets.only(bottom: 2.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(child: Text((index + 1).toString())),
                          Expanded(child: Text('Name')),
                          Expanded(child: Text('Address')),
                          Expanded(child: Text('Action'))
                        ],
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        )
      ),
    );
  }
}