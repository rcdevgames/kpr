import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class Tables extends StatefulWidget {
  String type;
  Map<String, dynamic> data;
  Tables({Key key, this.type, this.data}) : super(key: key);

  @override
  _TablesState createState() => _TablesState();
}

class _TablesState extends State<Tables> {
  final formatCurrency = new NumberFormat.currency(symbol: "Rp. ", decimalDigits: 0);
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

  Widget fillTable() {
    if (widget.type == 'flat') {
      // return Container();
      num jumlah_pinjam = widget.data['jumlah_pinjam'];
      num bunga = widget.data['angsuran'] - widget.data['pokok'];
      return Expanded(
        child: Container(
          child: ListView.builder(
            itemCount: widget.data['tenor'] + 1,
            itemBuilder: (BuildContext context, int index) {
              if(index == 0) {
                return Container(
                  padding: EdgeInsets.only(bottom: 2.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(child: Text((index).toString())),
                      Expanded(child: Text("0")),
                      Expanded(child: Text("0")),
                      Expanded(child: Text("0")),
                      Expanded(child: Text("${formatCurrency.format(jumlah_pinjam)}")),
                    ],
                  ),
                );
              }else{
                jumlah_pinjam = jumlah_pinjam - widget.data['pokok'];
                return Container(
                  padding: EdgeInsets.only(bottom: 2.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(child: Text((index).toString())),
                      Expanded(child: Text("${formatCurrency.format(widget.data['pokok'])}")),
                      Expanded(child: Text("${formatCurrency.format(bunga)}")),
                      Expanded(child: Text("${formatCurrency.format(widget.data['angsuran'])}")),
                      Expanded(child: Text("${formatCurrency.format(jumlah_pinjam)}")),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      );
    } else {
      num sisa_hutang = widget.data['jumlah_pinjam'];
      return Expanded(
        child: Container(
          child: ListView.builder(
            itemCount: widget.data['tenor'] + 1,
            itemBuilder: (BuildContext context, int index) {
              if(index == 0) {
                return Container(
                  padding: EdgeInsets.only(bottom: 2.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(child: Text((index).toString())),
                      Expanded(child: Text("0")),
                      Expanded(child: Text("0")),
                      Expanded(child: Text("0")),
                      Expanded(child: Text("${formatCurrency.format(sisa_hutang)}")),
                    ],
                  ),
                );
              }else{
                var bunga = widget.data['suku_bunga'] * sisa_hutang;
                var pokok = widget.data['angsuran'] - bunga;
                sisa_hutang = ((sisa_hutang - pokok) > 0) ? sisa_hutang - pokok : 0;
                return Container(
                  padding: EdgeInsets.only(bottom: 2.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(child: Text((index).toString())),
                      Expanded(child: Text("${formatCurrency.format(pokok)}")),
                      Expanded(child: Text("${formatCurrency.format(bunga)}")),
                      Expanded(child: Text("${formatCurrency.format(widget.data['angsuran'])}")),
                      Expanded(child: Text("${formatCurrency.format(sisa_hutang)}")),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      );
    }
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
    print(widget.data);
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
                  Expanded(child: Text('Total Cicilan')),
                  Expanded(child: Text('Sisa Pinjaman'))
                ],
              ),
            ),
            fillTable(),
            Container(
              padding: EdgeInsets.only(bottom: 5.0),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(width: 1.0))
              ),
              child: Row(
                children: <Widget>[
                  Expanded(child: Text('Total')),
                  Expanded(child: Text("${formatCurrency.format(widget.data['jumlah_pinjam'])}")),
                  Expanded(child: Text("${formatCurrency.format(widget.data['total_bunga'])}")),
                  Expanded(child: Text("${formatCurrency.format(widget.data['total_bayar'])}")),
                  Expanded(child: Text(''))
                ],
              ),
            ),
          ],
        )
      ),
    );
  }
}