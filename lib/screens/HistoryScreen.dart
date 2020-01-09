import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:qrcode_app/common/Common.dart';
import 'package:qrcode_app/config/ads.dart';
import 'package:qrcode_app/main.dart';
import 'package:qrcode_app/screens/ResultScreen.dart';

class HistoryScreen extends StatefulWidget {
  HistoryScreen({Key key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  AdmobInterstitial interstitialAd;
  AdmobBannerSize bannerSize;
  void getString() {
    Common.listhis = prefs.getStringList(Common.LIST_THIS);
  }

  @override
  void initState() {
    super.initState();
    getString();
    bannerSize = AdmobBannerSize.MEDIUM_RECTANGLE;
    interstitialAd = AdmobInterstitial(
      adUnitId: interUnitId,
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.closed) interstitialAd.load();
        handleEvent(event, args, 'Interstitial');
      },
    );
    interstitialAd.load();
  }

  void handleEvent(
      AdmobAdEvent event, Map<String, dynamic> args, String adType) {
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

  void showSnackBar(String content) {
    scaffoldState.currentState.showSnackBar(SnackBar(
      content: Text(content),
      duration: Duration(milliseconds: 1500),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Center(
            child: Text("History", style: TextStyle(color: Colors.white))),
        actions: <Widget>[
          GestureDetector(
            onTap: () async {
              if (await interstitialAd.isLoaded) {
                interstitialAd.show();
              } else {
                showSnackBar("Reward ad is still loading...");
              }
            },
            child: Container(
              height: 40,
              width: 40,
              child: Image.asset(
                "assets/images/vip.png",
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 1,
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Common.listhis != null && Common.listhis.length != 0
                      ? ListView.builder(
                          itemCount: Common.listhis.length,
                          itemBuilder: (context, int index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.05,
                                right: MediaQuery.of(context).size.width * 0.05,
                              ),
                              child: Card(
                                color: Colors.grey,
                                child: ListTile(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ResultScreen(
                                                  id: Common.listhis[index],
                                                )));
                                  },
                                  leading: Common.listhis[index]
                                          .contains(new RegExp(r'[0-9]'))
                                      ? Icon(
                                          Icons.call,
                                          color: Colors.green,
                                        )
                                      : Icon(
                                          Icons.textsms,
                                          color: Colors.white,
                                        ),
                                  title: Text(Common.listhis[index],
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Text("No data",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                        )),
              Container(
                alignment: Alignment.bottomCenter,
                child: AdmobBanner(
                  adUnitId: bannerId,
                  adSize: bannerSize,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
