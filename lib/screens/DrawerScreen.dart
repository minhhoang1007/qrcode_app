import 'package:firebase_admob/firebase_admob.dart';
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
  String urlNangcap = 'https://flutter.dev';
  String urlFeedback = 'https://flutter.dev';
  String urlMoreApp = 'https://flutter.dev';
  String urlTest = 'https://flutter.dev';
  String urlChinhsach = 'https://flutter.dev';
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // BannerAd _bannerAd;
  // BannerAd createBannerAd() {
  //   return BannerAd(
  //       adUnitId: bannerId,
  //       size: AdSize.mediumRectangle,
  //       targetingInfo: ADS().targetingInfo,
  //       listener: (MobileAdEvent event) {
  //         print("BannerAd $event");
  //       });
  // }
  @override
  void initState() {
    super.initState();
    // FirebaseAdMob.instance.initialize(
    //   appId: bannerId,
    // );
    // _bannerAd = createBannerAd()
    //   ..load()
    //   ..show(
    //     anchorOffset: 60.0,
    //     anchorType: AnchorType.bottom,
    //   );
  }

  @override
  void dispose() {
    //_bannerAd.dispose();
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
        color: Colors.black,
        child: ListView(
          children: <Widget>[
            ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HistoryScreen()));
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
              onTap: () {
                _launchURL(urlNangcap);
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
                _launchURL(urlTest);
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
            ListTile(
              onTap: () {
                _launchURL(urlChinhsach);
              },
              leading: Icon(
                Icons.check_circle,
                color: Colors.white,
              ),
              title: Text(
                "Policy",
                style: TextStyle(color: Colors.white),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.card_giftcard,
                color: Colors.white,
              ),
              title: Text(
                "Other application",
                style: TextStyle(color: Colors.white),
              ),
            ),
            Container(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
