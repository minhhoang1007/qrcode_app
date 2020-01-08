import 'dart:io';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_code_scanner/qr_scanner_overlay_shape.dart';
import 'package:qrcode_app/common/Common.dart';
import 'package:qrcode_app/config/ads.dart';
import 'package:qrcode_app/main.dart';
import 'package:qrcode_app/screens/DrawerScreen.dart';
import 'package:qrcode_app/screens/HistoryScreen.dart';
import 'package:qrcode_app/screens/NewQRScreen.dart';
import 'package:qrcode_app/screens/ResultScreen.dart';
import 'package:qrcode_app/screens/SavedScreen.dart';
import 'package:qr_code_tools/qr_code_tools.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File imageFile;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  var qrText = "";
  bool flash;
  QRViewController controller;
  AdmobBannerSize bannerSize;
  AdmobInterstitial interstitialAd;
  AdmobReward rewardAd;

  // truy cap thu vien anh
  void _openGallary(BuildContext context) async {
    controller.pauseCamera();
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery);
    decode(picture.path);
  }

  bool isload = false;
  @override
  void initState() {
    super.initState();
    MyApp.platform.invokeMethod("rateAuto");
    bannerSize = AdmobBannerSize.BANNER;
    interstitialAd = AdmobInterstitial(
      adUnitId: interUnitId,
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.closed) interstitialAd.load();
        handleEvent(event, args, 'Interstitial');
      },
    );

    rewardAd = AdmobReward(
        adUnitId: videoId,
        listener: (AdmobAdEvent event, Map<String, dynamic> args) {
          if (event == AdmobAdEvent.closed) {
            rewardAd.load();
          }
          ;
          handleEvent(event, args, 'Reward');
        });

    interstitialAd.load();
    rewardAd.load();

    Common.listhis = [];
    flash = false;
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
        // intent to screen
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
  //play video ads

  //Save history
  Future saveQR(String name) async {
    Common.listhis.add(name);
    return prefs.setStringList("list", Common.listhis);
  }

  //QR Code
  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      print(scanData);
      setState(() {
        qrText = scanData;
      });
      saveQR(qrText);
      controller.pauseCamera();
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ResultScreen(
                    id: qrText,
                    callBack: () {
                      controller.resumeCamera();
                    },
                  )));
    });
  }

  //Qr code image
  Future decode(String file) async {
    String data = await QrCodeToolsPlugin.decodeFrom(file);
    qrText = data;
    saveQR(qrText);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ResultScreen(
                  id: qrText,
                  callBack: () {
                    controller.resumeCamera();
                  },
                )));
  }

  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
  }

  //Dialog
  @override
  void _showDialogNew() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            titlePadding: EdgeInsets.all(0),
            contentPadding: EdgeInsets.all(10),
            title: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.orange,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      "Unlock Generate QR Code",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black),
                  ),
                  height: 200,
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          height: 70,
                          width: 70,
                          child: Image.asset("assets/images/tien.jpg")),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Text("Use this function forever!!!",
                            style: TextStyle(fontSize: 13)),
                      ),
                      Text(
                        "15.000 đ",
                        style: TextStyle(color: Colors.blue),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          height: 40,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              "BUY NOW",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black),
                  ),
                  height: 200,
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          height: 70,
                          width: 70,
                          child: Image.asset("assets/images/play.jpg")),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Text(
                          "Get 2 times free to generate!!!",
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () async {
                          Navigator.of(context).pop();
                          setState(() {
                            isload = true;
                          });
                          if (await rewardAd.isLoaded) {
                            rewardAd.show();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NewQRScreen(),
                                ));
                          } else {
                            showSnackBar("Interstitial ad is still loading...");
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 40,
                          width: 110,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              "WATCH NOW",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: IconButton(
            icon: Icon(
              Icons.list,
              color: Colors.white,
            ),
            iconSize: 30,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DrawerScreen(),
                  ));
            },
          ),
        ),
        title: Padding(
          padding:
              EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.3),
          child: GestureDetector(
            onTap: () {
              flash ? controller.toggleFlash() : Container();
              setState(() {
                flash ? flash = false : flash = true;
              });
            },
            child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(120),
                image: DecorationImage(
                  image: AssetImage("assets/images/iconthunder.png"),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () async {
              print("Load video");
              if (await rewardAd.isLoaded) {
                rewardAd.show();
              } else {
                showSnackBar("Interstitial ad is still loading...");
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
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                  overlay: QrScannerOverlayShape(
                    borderColor: Colors.white,
                    borderLength: 30,
                    borderWidth: 10,
                    cutOutSize: 300,
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.5,
            child: Container(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1,
                  right: MediaQuery.of(context).size.width * 0.1),
              width: MediaQuery.of(context).size.width * 1,
              height: MediaQuery.of(context).size.height * 0.05,
              child: Center(
                child: Divider(
                  color: Colors.red,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.1,
            child: Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.05,
                right: MediaQuery.of(context).size.width * 0.05,
              ),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        _showDialogNew();
                      },
                      child: Column(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(60),
                              color: Colors.black54,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text("Generate",
                              style: TextStyle(color: Colors.white))
                        ],
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SavedScreen(),
                            ));
                      },
                      child: Column(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(60),
                              color: Colors.black54,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.save,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text("Saved", style: TextStyle(color: Colors.white))
                        ],
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
                    ),
                    GestureDetector(
                      onTap: () {
                        _openGallary(context);
                        // decode(imageFile.path);
                      },
                      child: Column(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(60),
                              color: Colors.black54,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.image,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text("Scan Photo",
                              style: TextStyle(color: Colors.white))
                        ],
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HistoryScreen(),
                            ));
                      },
                      child: Column(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(60),
                              color: Colors.black54,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.history,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text("History", style: TextStyle(color: Colors.white))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.width * 1.4,
            left: MediaQuery.of(context).size.width * 0.05,
            right: MediaQuery.of(context).size.width * 0.05,
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(bottom: 20.0),
              child: AdmobBanner(
                adUnitId: bannerId,
                adSize: bannerSize,
                listener: (AdmobAdEvent event, Map<String, dynamic> args) {
                  handleEvent(event, args, 'Banner');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
