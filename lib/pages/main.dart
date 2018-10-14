import 'package:flutter/material.dart';
import 'package:kpr/pages/efektif.dart';
import 'package:kpr/pages/flat.dart';

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}

class MainPage extends StatefulWidget {

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  int _selectedDrawerIndex = 0;
  final drawerItems = [
    new DrawerItem("Simulasi Bunga Efektif", Icons.insert_chart),
    new DrawerItem("Simulasi Bunga Flat", Icons.insert_chart),
    // new DrawerItem("Logout", Icons.exit_to_app)
  ];

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new Efektif();
      case 1:
        return new Flat();

      default:
        return new Text("Error");
    }
  }

  _onSelectItem(int index) {
    setState(() {
      _selectedDrawerIndex = index;
    });
    Navigator.of(context).pop(); // close the drawer
  }
    
  @override
  Widget build(BuildContext context) {
    var drawerOptions = <Widget>[];
    for (var i = 0; i < drawerItems.length; i++) {
      var d = drawerItems[i];
      drawerOptions.add(
        new ListTile(
          leading: new Icon(d.icon),
          title: new Text(d.title),
          selected: i == _selectedDrawerIndex,
          onTap: () => _onSelectItem(i),
        )
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      drawer: Drawer(
        child: Container(
         padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          child: Column(children: drawerOptions)
        )
      ),
      resizeToAvoidBottomPadding: false,
      body: _getDrawerItemWidget(_selectedDrawerIndex),
    );
  }
}