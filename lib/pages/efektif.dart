import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:kpr/pages/table.dart';
import 'package:kpr/util/validator.dart';

class Efektif extends StatefulWidget {
  @override
  _EfektifState createState() => _EfektifState();
}

class _EfektifState extends State<Efektif> with ValidationMixin{
  final _formData = GlobalKey<FormState>();
  var _hargaCtrl = new MaskedTextController(mask: '000.000.000');
  var _dpCtrl = new MaskedTextController(mask: '000.000.000');
  var _jumlahCtrl = new MaskedTextController(mask: '000.000.000');
  var _bungaCtrl = new MaskedTextController(mask: '000.000.000');
  var _totalBayarCtrl = new MaskedTextController(mask: '000.000.000');
  var _totalBungaCtrl = new MaskedTextController(mask: '000.000.000');
  var _cicilanCtrl = new MaskedTextController(mask: '000.000.000');
  
  // Form Data
  String _harga;
  String _dp;
  String _jumlah_pinjam;
  String _tenor;
  String _bunga;
  String _totalBayar;
  String _totalBunga;
  String _cicilan;

  bool errorTenor = false;


  @override
  void initState(){
    super.initState();
   
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp
    ]);
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

  void _hitungCicilan() {
    final form = _formData.currentState;
    if(_tenor == null) {
      setState(() => errorTenor = true);
    }

    if (form.validate()) {
      form.save();
      if (errorTenor == false) {
        print('Fix Value : {"Harga" : $_harga},{"DP" : $_dp},{"Jumlah Pinjaman" : $_jumlah_pinjam},{"Bunga" : $_bunga}');
      }
    }
  }

  void _openTable() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => Tables('efektif')
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6.0),
      child: ListView(
        children: <Widget>[
          Card(
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formData,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _hargaCtrl,
                      keyboardType: TextInputType.number,
                      onSaved: (val) => _harga = val.replaceAll('.', ''),
                      validator: validateRequired,
                      decoration: InputDecoration(
                        prefixText: 'Rp. ',
                        labelText: 'Harga Properti',
                        contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 10.0)
                      ),
                    ),
                    TextFormField(
                      controller: _dpCtrl,
                      keyboardType: TextInputType.number,
                      onSaved: (val) => _dp = val.replaceAll('.', ''),
                      validator: validateRequired,
                      decoration: InputDecoration(
                        prefixText: 'Rp. ',
                        labelText: 'Uang Muka / DP 20% (Default)',
                        contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 10.0)
                      ),
                    ),
                    TextFormField(
                      controller: _jumlahCtrl,
                      keyboardType: TextInputType.number,
                      onSaved: (val) => _jumlah_pinjam = val.replaceAll('.', ''),
                      validator: validateRequired,
                      decoration: InputDecoration(
                        prefixText: 'Rp. ',
                        labelText: 'Jumlah Pinjaman / Hutang',
                        contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 10.0)
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 13.0, left: 7.0),
                                child: Text('Tenor / Jangka Waktu', style: TextStyle(fontSize: 13.0, color: Colors.black54))
                              ),
                              Container(
                                  width: 300.0,
                                  height: 30.0,
                                  decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(width: 1.0, color: errorTenor == false ?Colors.black45 : Colors.red))
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: ButtonTheme(
                                      alignedDropdown: true,
                                      child: DropdownButton(
                                        value: _tenor,
                                        onChanged: (val) => setState((){
                                          _tenor = val;
                                          errorTenor = false;
                                        }),
                                        items: [
                                          DropdownMenuItem(
                                            value: '10',
                                            child: Text('10'),
                                          ),
                                          DropdownMenuItem(
                                            value: '15',
                                            child: Text('15'),
                                          ),
                                          DropdownMenuItem(
                                            value: '20',
                                            child: Text('20'),
                                          ),
                                        ]
                                      ),
                                    ),
                                  ),
                              ),
                              errorTenor != false ?
                              Padding(
                                padding: EdgeInsets.only(top: 7.0, right: 60.0),
                                child: Text('Required!', textAlign: TextAlign.start, style: TextStyle(color: Colors.red, fontSize: 12.0)),
                              ) : Container()
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: EdgeInsets.only(left: 15.0, top: 30.0),
                            child: Text("Tahun", style: TextStyle( fontSize: 15.0)),
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            controller: _bungaCtrl,
                            keyboardType: TextInputType.number,
                            onSaved: (val) => _bunga = val.replaceAll('.', ''),
                            validator: validateRequired,
                            decoration: InputDecoration(
                              labelText: 'Bunga',
                              contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 10.0)
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: EdgeInsets.only(left: 15.0, top: 30.0),
                            child: Text("% / Tahun", style: TextStyle( fontSize: 15.0)),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Material(
                        shadowColor: Colors.redAccent.shade100,
                        child: MaterialButton(
                          elevation: 3.0,
                          minWidth: 200.0,
                          height: 40.0,
                          onPressed: _hitungCicilan,
                          color: Colors.red,
                          child: Text("Hitung", style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Card(
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Bunga Efektif', style: TextStyle(fontSize: 23.0, fontWeight: FontWeight.w500)),
                  SizedBox(width: 10.0),
                  TextFormField(
                    controller: _totalBayarCtrl,
                    enabled: false,
                    decoration: InputDecoration(
                      prefixText: 'Rp. ',
                      labelText: 'Total Bayar',
                      contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 10.0)
                    ),
                  ),
                  TextFormField(
                    controller: _totalBungaCtrl,
                    enabled: false,
                    decoration: InputDecoration(
                      prefixText: 'Rp. ',
                      labelText: 'Total Bunga',
                      contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 10.0)
                    ),
                  ),
                  TextFormField(
                    controller: _cicilanCtrl,
                    enabled: false,
                    decoration: InputDecoration(
                      prefixText: 'Rp. ',
                      labelText: 'Cicilan / Bulan',
                      contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 10.0)
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                      child: Material(
                        shadowColor: Colors.redAccent.shade100,
                        child: MaterialButton(
                          elevation: 3.0,
                          minWidth: 200.0,
                          height: 40.0,
                          onPressed: _openTable,
                          color: Colors.red,
                          child: Text("Tabel Bunga Efektif", style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      )
    );
  }
}