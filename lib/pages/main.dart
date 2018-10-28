import 'package:flutter/material.dart';
import 'package:kpr/pages/efektif.dart';
import 'package:kpr/pages/flat.dart';
import 'package:firebase_admob/firebase_admob.dart';

class MainPage extends StatefulWidget {

  @override
  _MainPageState createState() => _MainPageState();
}

const String testDevice = 'YOUR_DEVICE_ID';

class _MainPageState extends State<MainPage> {
  static final MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: testDevice != null ? <String>[testDevice] : null,
    keywords: <String>['Simulasi kpr', 'Kalkulator kpr', 'kpr', 'rumah', 'cicilan', 'kredit rumah', 'apartemen'],
    birthday: DateTime.now(),
    childDirected: true,
    gender: MobileAdGender.male
  );

  BannerAd _bannerAd;
  InterstitialAd _interstitialAd;
  PageController _pageController;
  int _page = 0;

  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: BannerAd.testAdUnitId,
      size: AdSize.banner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event $event");
      },
    );
  }

  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
      adUnitId: InterstitialAd.testAdUnitId,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("InterstitialAd event $event");
      },
    );
  }

  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance.initialize(appId: FirebaseAdMob.testAppId);
    _bannerAd = createBannerAd()..load()..show(anchorType: AnchorType.top);
    _interstitialAd = createInterstitialAd()..load();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    _pageController.dispose();
    super.dispose();
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
          'Simulasi KPR',
          style: TextStyle(color: const Color(0xFFFFFFFF)),
        ),
      ),
      body: PageView(
        children: [
          Efektif(ads: _interstitialAd),
          Flat(ads: _interstitialAd)
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