import 'package:flutter/material.dart';
import 'package:kpr/pages/efektif.dart';
import 'package:kpr/pages/flat.dart';

class MainPage extends StatefulWidget {

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  PageController _pageController;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }


  void navigationTapped(int page) {
    // Animating to the page.
    // You can use whatever duration and curve you like
    _pageController.animateToPage(page,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Perhitungan KPR',
          style: TextStyle(color: const Color(0xFFFFFFFF)),
        ),
      ),
      body: PageView(
        children: [
          Efektif(),
          Flat()
        ],
        onPageChanged: onPageChanged,
        controller: _pageController,
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
              // sets the background color of the `BottomNavigationBar`
              canvasColor: Colors.red,
            ), // sets the inactive color of the `BottomNavigationBar`
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.assessment,
                color: const Color(0xFFFFFFFF),
              ),
              title: Text(
                "Bunga Efektif",
                style: TextStyle(
                  color: const Color(0xFFFFFFFF),
                ),
              ),
              activeIcon: Icon(
                Icons.assessment,
                color: const Color(0xFFfffa00),
              )
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.assessment,
                color: const Color(0xFFFFFFFF),
              ),
              title: Text(
                "Bunga Flat",
                style: TextStyle(
                  color: const Color(0xFFFFFFFF),
                ),
              ),
              activeIcon: Icon(
                Icons.assessment,
                color: const Color(0xFFfffa00),
              )
            ),
          ],
          onTap: navigationTapped,
          currentIndex: _page,
        ),
      ),
    );
  }
}