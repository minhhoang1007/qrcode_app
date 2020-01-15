import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:qrcode_app/config/ads.dart';
import 'package:qrcode_app/screens/HistoryScreen.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerScreen extends StatefulWidget {
  DrawerScreen({Key key}) : super(key: key);

  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  String urlNangcap = 'http://play.google.com/store/apps/details?id=com.qrcode.barcode.qrscanner';
  String urlFeedback = 'mailto:tahanh.aib@gmail.com?subject=QR Code Feedback&body=';
  String urlMoreApp = 'http://play.google.com/store/apps/details?id=com.qrcode.barcode.qrscanner';
  String urlTest = 'http://play.google.com/store/apps/details?id=com.qrcode.barcode.qrscanner';
  String urlChinhsach = 'http://play.google.com/store/apps/details?id=com.qrcode.barcode.qrscanner';
  AdmobBannerSize bannerSize;
  AdmobInterstitial interstitialAd;
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();

  @override
  void initState() {
    bannerSize = AdmobBannerSize.MEDIUM_RECTANGLE;
    interstitialAd = AdmobInterstitial(
      adUnitId: interUnitId,
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.closed) interstitialAd.load();
        handleEvent(event, args, 'Interstitial');
      },
    );
    interstitialAd.load();
    super.initState();
  }

  void handleEvent(AdmobAdEvent event, Map<String, dynamic> args, String adType) {
    switch (event) {
      case AdmobAdEvent.loaded:
        showSnackBar('New Admob $adType Ad loaded!');
        break;
      case AdmobAdEvent.opened:
        showSnackBar('Admob $adType Ad opened!');
        break;
      case AdmobAdEvent.closed:
        showSnackBar('Admob $adType Ad closed!');
        break;
      case AdmobAdEvent.failedToLoad:
        showSnackBar('Admob $adType failed to load. :(');
        break;
      case AdmobAdEvent.rewarded:
        break;
      default:
    }
  }

  @override
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void showSnackBar(String content) {
    scaffoldState.currentState.showSnackBar(SnackBar(
      content: Text(content),
      duration: Duration(milliseconds: 1500),
    ));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("QR-BarCode"),
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.black),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[
                  ListTile(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryScreen()));
                    },
                    leading: Icon(
                      Icons.history,
                      color: Colors.white,
                    ),
                    title: Text(
                      "History",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ListTile(
                    onTap: () async {
                      if (await interstitialAd.isLoaded) {
                        interstitialAd.show();
                      } else {
                        showSnackBar("Reward ad is still loading...");
                      }
                    },
                    leading: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(),
                      child: Image.asset(
                        "assets/images/vip.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                    title: Text(
                      " Upgrade version VIP",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      _launchURL(urlFeedback);
                    },
                    leading: Icon(
                      Icons.comment,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Feedback to the developer",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      _launchURL(urlNangcap);
                    },
                    leading: Icon(
                      Icons.system_update_alt,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Check for updated version",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  // ListTile(
                  //   onTap: () {
                  //     _launchURL(urlChinhsach);
                  //   },
                  //   leading: Icon(
                  //     Icons.check_circle,
                  //     color: Colors.white,
                  //   ),
                  //   title: Text(
                  //     "Policy",
                  //     style: TextStyle(color: Colors.white),
                  //   ),
                  // ),
                  // ListTile(
                  //   leading: Icon(
                  //     Icons.card_giftcard,
                  //     color: Colors.white,
                  //   ),
                  //   title: Text(
                  //     "Other application",
                  //     style: TextStyle(color: Colors.white),
                  //   ),
                  // ),
                  Container(
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              alignment: Alignment.bottomCenter,
              child: AdmobBanner(
                adUnitId: bannerId,
                adSize: bannerSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
