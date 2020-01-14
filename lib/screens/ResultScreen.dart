import 'package:admob_flutter/admob_flutter.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qrcode_app/config/ads.dart';
import 'package:qrcode_app/screens/HomeScreen.dart';
import 'package:url_launcher/url_launcher.dart';

class ResultScreen extends StatefulWidget {
  String id;
  var callBack;
  ResultScreen({this.id, Key key, this.callBack}) : super(key: key);

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  String urlSearch;
  String urlWeb;
  AdmobBannerSize bannerSize;

  AdmobInterstitial interstitialAd;
  Future<void> _shareText() async {
    try {
      Share.text('ID Product: ', widget.id, 'text/plain');
    } catch (e) {
      print('error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    urlSearch = 'https://www.google.com/search?q=${widget.id}';
    urlWeb = 'https://${widget.id}';
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

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.callBack();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: GestureDetector(
          onTap: () {
            // Navigator.of(context).pushAndRemoveUntil(
            //     MaterialPageRoute(builder: (context) => HomeScreen()), (Route<dynamic> route) => false);
            Navigator.of(context).pop();
          },
          child: Container(
            height: 40,
            width: 40,
            child: Icon(
              Icons.home,
              color: Colors.white,
            ),
          ),
        ),
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
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(120),
                image: DecorationImage(
                  image: AssetImage("assets/images/vip.png"),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.1),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.1,
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 10, top: 10),
                        child: widget.id.contains(new RegExp(r'[0-9]'))
                            ? Text("ID product: \n" + widget.id)
                            : Text("Link URL: \n" + widget.id),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Clipboard.setData(
                                    ClipboardData(text: widget.id));
                                Fluttertoast.showToast(
                                    msg: "Copied to clipboard",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIos: 1,
                                    backgroundColor: Colors.white,
                                    textColor: Colors.orange,
                                    fontSize: 16.0);
                              },
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.black87,
                                  borderRadius: BorderRadius.circular(120),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.content_copy,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Text("Copy", style: TextStyle(color: Colors.white))
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () async {
                                await _shareText();
                              },
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.black87,
                                  borderRadius: BorderRadius.circular(120),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.share,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Text("Share", style: TextStyle(color: Colors.white))
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                _launchURL(urlSearch);
                              },
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(120),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.search,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Text("Search",
                                style: TextStyle(color: Colors.white))
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                _launchURL(urlWeb);
                              },
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.purple,
                                  borderRadius: BorderRadius.circular(120),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.network_cell,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Text("Web", style: TextStyle(color: Colors.white))
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  // Padding(
                  //   padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.3),
                  //   child: GestureDetector(
                  //     onTap: () {
                  //       widget.callBack();
                  //       Navigator.of(context).pop();
                  //     },
                  //     child: Column(
                  //       children: <Widget>[
                  //         Container(
                  //           height: MediaQuery.of(context).size.height * 0.05,
                  //           width: MediaQuery.of(context).size.width * 0.35,
                  //           decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(32),
                  //           ),
                  //           child: Center(
                  //             child: Image.asset(
                  //               "assets/images/qrcode.png",
                  //               fit: BoxFit.fill,
                  //             ),
                  //           ),
                  //         ),
                  //         SizedBox(
                  //           height: 5,
                  //         ),
                  //         Text(
                  //           "Scan new",
                  //           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  Container(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () {
                        widget.callBack();
                        Navigator.of(context).pop();

                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => HomeScreen()));
                      },
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: MediaQuery.of(context).size.height * 0.05,
                            width: MediaQuery.of(context).size.width * 0.35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(32),
                            ),
                            child: Center(
                              child: Image.asset(
                                "assets/images/qrcode.png",
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Scan new",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.center,
                child: AdmobBanner(
                  adUnitId: bannerId,
                  adSize: bannerSize,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
