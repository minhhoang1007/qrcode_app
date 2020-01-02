import 'dart:io';
import 'package:firebase_admob/firebase_admob.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File imageFile;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  var qrText = "";
  bool flash;
  QRViewController controller;

  // truy cap thu vien anh
  void _openGallary(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery);
    this.setState(() {
      imageFile = picture;
    });
  }

  //Quang Cao
  BannerAd _bannerAd;
  int _coins = 0;
  BannerAd createBannerAd() {
    return BannerAd(
        adUnitId: bannerId,
        size: AdSize.banner,
        targetingInfo: ADS().targetingInfo,
        listener: (MobileAdEvent event) {
          print("BannerAd $event");
        });
  }

  bool isload = false;
  @override
  void initState() {
    super.initState();
    MyApp.platform.invokeMethod("rateAuto");
    FirebaseAdMob.instance.initialize(
      appId: bannerId,
    );
    _bannerAd = createBannerAd()
      ..load()
      ..show(
        anchorType: AnchorType.bottom,
      );
    RewardedVideoAd.instance
        .load(adUnitId: videoId, targetingInfo: ADS().targetingInfo);
    RewardedVideoAd.instance.listener =
        (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
      print("RewardedVideoAd event $event");
      if (event == RewardedVideoAdEvent.rewarded) {
        setState(() {
          _coins += rewardAmount;
        });
      }
      if (event == RewardedVideoAdEvent.closed) {
        setState(() {
          isload = false;
        });
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewQRScreen(),
            ));
      }
    };
    Common.listhis = [];
    flash = false;
  }

  //play video ads
  playAd() {
    if (_coins == 0) {
      setState(() {
        RewardedVideoAd.instance
            .load(adUnitId: videoId, targetingInfo: ADS().targetingInfo);
      });

      RewardedVideoAd.instance.show();
      print("Coins $_coins");
    } else {
      setState(() {
        _coins += -1;
        RewardedVideoAd.instance
            .load(adUnitId: videoId, targetingInfo: ADS().targetingInfo);
      });
      print("Coins $_coins");
    }
  }

  //Save history
  Future<Null> saveQR(String name) async {
    Common.listhis.add(name);
    return prefs.setStringList("list", Common.listhis);
  }

  //QR Code
  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrText = scanData;
      });
      saveQR(qrText);
      qrText == null
          ? Container()
          : Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ResultScreen(id: qrText)));
    });
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    controller?.dispose();
    super.dispose();
  }

  //Dialog
  @override
  void _showDialogNew() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.orange,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      "Unlock Generate QR Code",
                      style: TextStyle(color: Colors.white, fontSize: 15),
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
                  height: 220,
                  width: MediaQuery.of(context).size.width * 0.32,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset("assets/images/vip.png"),
                      Center(
                        child: Text("Use this function forever!!!",
                            style: TextStyle(fontSize: 13)),
                      ),
                      Text(
                        "15.000 đ",
                        style: TextStyle(color: Colors.blue),
                      ),
                      GestureDetector(
                        onTap: () {},
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
                SizedBox(
                  width: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black),
                  ),
                  height: 220,
                  width: MediaQuery.of(context).size.width * 0.32,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset("assets/images/vip.png"),
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
                        onTap: () {
                          Navigator.of(context).pop();
                          setState(() {
                            isload = true;
                          });
                          playAd();
                        },
                        child: Container(
                          height: 40,
                          width: 100,
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
        leading: IconButton(
          icon: Icon(
            Icons.list,
            color: Colors.white,
          ),
          iconSize: 40,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DrawerScreen(),
                ));
          },
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
            onTap: () {
              print("Load video");
              playAd();
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
            bottom: MediaQuery.of(context).size.height * 0.05,
            child: Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.1,
              ),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        _showDialogNew();
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => NewQRScreen(),
                        //     ));
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
                          Text("Tạo mã", style: TextStyle(color: Colors.white))
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
                          Text("Đã lưu", style: TextStyle(color: Colors.white))
                        ],
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.1,
                    ),
                    GestureDetector(
                      onTap: () {
                        _openGallary(context);
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
                          Text("Quét ảnh",
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
                          Text("Lịch sử", style: TextStyle(color: Colors.white))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
