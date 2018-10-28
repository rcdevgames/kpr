import 'dart:math';

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
  var _hargaCtrl = new MoneyMaskedTextController(thousandSeparator: ',', decimalSeparator: '.');
  var _dpCtrl = new MoneyMaskedTextController(thousandSeparator: ',', decimalSeparator: '.');
  var _jumlahCtrl = new MoneyMaskedTextController(thousandSeparator: ',', decimalSeparator: '.');
  var _totalBayarCtrl = new MoneyMaskedTextController(thousandSeparator: ',', decimalSeparator: '.');
  var _totalBungaCtrl = new MoneyMaskedTextController(thousandSeparator: ',', decimalSeparator: '.');
  var _cicilanCtrl = new MoneyMaskedTextController(thousandSeparator: ',', decimalSeparator: '.');
  var _bungaCtrl = new TextEditingController();
  ScrollController _scrollController = new ScrollController();
  
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
  bool hasCount = false;

  Map<String, dynamic> data;

  @override
  void initState(){
    super.initState();
   
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp
    ]);

    _hargaCtrl.addListener(_autoCounting);
    _dpCtrl.addListener(_changeDP);
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
        setState(() {
          _harga = _harga.substring(0, _harga.indexOf('.'));          
          _dp = _dp.substring(0, _dp.indexOf('.'));          
          _jumlah_pinjam = _jumlah_pinjam.substring(0, _jumlah_pinjam.indexOf('.'));          
        });
        print('Fix Value : {"Harga" : $_harga},{"DP" : $_dp},{"Jumlah Pinjaman" : $_jumlah_pinjam},{"Bunga" : $_bunga},{"Tenor" : $_tenor}');
        // setState(()=> hasCount = true );

        num suku_bunga = (num.parse(_bunga)/12) / 100;
        num periode = num.parse(_tenor) * 12;

        num angsuran = num.parse(_jumlah_pinjam) * suku_bunga * (pow((1 + suku_bunga), periode) / (pow((1 + suku_bunga), periode) - 1));

        num sisa_hutang = num.parse(_jumlah_pinjam);
        num total_pokok = 0;
        num total_bunga = 0; 

        for (var i = 1; i < periode + 1; i++) {
          var bunga = suku_bunga * sisa_hutang;
          var pokok = angsuran - bunga;

          total_bunga = total_bunga + bunga;
          total_pokok = total_pokok + pokok;

          sisa_hutang = ((sisa_hutang - pokok) > 0) ? sisa_hutang - pokok : 0;
          print('Hasil : {"Periode" : $i},{"Sisa Pokok" : $pokok},{"Sisa Bunga" : $bunga},{"Sisa Hutang" : $sisa_hutang}');
        }

        print('New Value : {"suku bunga" : $suku_bunga},{"periode" : $periode},{"angsuran" : $angsuran}');
        print('New Value : {"Total Pokok" : $total_pokok},{"Total Bunga" : $total_bunga},{"Sisa Hutang" : $sisa_hutang}');

        _totalBayarCtrl.updateValue(angsuran * periode);
        _totalBungaCtrl.updateValue(total_bunga);
        _cicilanCtrl.updateValue(angsuran);

        setState(()=> hasCount = true );
        
        _scrollController.animateTo(
          (100.0 * 2),
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 300),
        );

        data = {
          "tenor": periode,
          "suku_bunga": suku_bunga,
          "angsuran": angsuran,
          "total_bunga": total_bunga,
          "jumlah_pinjam": num.parse(_jumlah_pinjam),
          "total_bayar": angsuran * periode
        };

        print(data);

      }
    }
  }

  void _resetCount() {
    _hargaCtrl.updateValue(0.00);
    _dpCtrl.updateValue(0.00);
    _jumlahCtrl.updateValue(0.00);
    _bungaCtrl.clear();
    
    setState(()=> _tenor = null);

    _scrollController.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );

     setState(()=> hasCount = false );
  }

  void _autoCounting() {
    var harga = _hargaCtrl.text;
    var dp = _dpCtrl.text;
    if (harga != '0.00') {
      num result = 0.2 *  double.parse(harga.replaceAll(',', ''));
      num result_ = num.parse(harga.replaceAll(',', '')) - num.parse(dp.replaceAll(',', ''));
      print(result);
      _dpCtrl.updateValue(result);
      _jumlahCtrl.updateValue(result_);
    }
  }

  void _changeDP() {
    var harga = _hargaCtrl.text;
    var dp = _dpCtrl.text;
     num result_ = num.parse(harga.replaceAll(',', '')) - num.parse(dp.replaceAll(',', ''));
     _jumlahCtrl.updateValue(result_);
  }

  void _openTable() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => Tables(type:'efektif', data: data)
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6.0),
      child: ListView(
        controller: _scrollController,
        children: <Widget>[
          Card(
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formData,
                // onChanged: _autoCounting,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _hargaCtrl,
                      keyboardType: TextInputType.number,
                      onSaved: (val) => _harga = val.replaceAll(',', ''),
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
                      onSaved: (val) => _dp = val.replaceAll(',', ''),
                      validator: validateNumber,
                      decoration: InputDecoration(
                        prefixText: 'Rp. ',
                        labelText: 'Uang Muka / DP 20% (Default)',
                        contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 10.0)
                      ),
                    ),
                    TextFormField(
                      controller: _jumlahCtrl,
                      keyboardType: TextInputType.number,
                      onSaved: (val) => _jumlah_pinjam = val.replaceAll(',', ''),
                      // validator: validateRequired,
                      enabled: false,
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
                            onSaved: (val) => _bunga = val,
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
                          onPressed: !hasCount ? _hitungCicilan : _resetCount,
                          color: Colors.red,
                          child: !hasCount ? Text("Hitung", style: TextStyle(color: Colors.white)) : Text("Reset", style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          hasCount ? 
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
          ) : Container()
        ],
      )
    );
  }
}