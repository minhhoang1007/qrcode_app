import 'package:admob_flutter/admob_flutter.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrcode_app/common/Common.dart';
import 'package:qrcode_app/config/ads.dart';
import 'package:qrcode_app/main.dart';
import 'package:qrcode_app/screens/NewQRScreen.dart';

class SavedScreen extends StatefulWidget {
  var callBack;
  SavedScreen({Key key, this.callBack}) : super(key: key);

  @override
  _SavedScreenState createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  AdmobBannerSize bannerSize;
  AdmobReward rewardAd;
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  void getString() {
    Common.img = prefs.getStringList(Common.LIST_TOW);
  }

  void removeValues(String nam) {
    Common.img.remove(nam);
    prefs.setStringList(Common.LIST_TOW, Common.img).then((onValue) {
      if (onValue)
        setState(() {
          Common.img;
        });
    });
  }

  @override
  void initState() {
    bannerSize = AdmobBannerSize.MEDIUM_RECTANGLE;
    rewardAd = AdmobReward(
        adUnitId: videoId,
        listener: (AdmobAdEvent event, Map<String, dynamic> args) {
          if (event == AdmobAdEvent.closed) {
            rewardAd.load();
          }
          handleEvent(event, args, 'Reward');
        });
    rewardAd.load();
    getString();
    super.initState();
  }

  //Share
  Future<void> _shareText(String ind) async {
    try {
      Share.text('ID Product: ', ind, 'text/plain');
    } catch (e) {
      print('error: $e');
    }
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
        showDialog(
          context: scaffoldState.currentContext,
          builder: (BuildContext context) {
            return WillPopScope(
              child: AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('Reward callback fired. Thanks Andrew!'),
                    Text('Type: ${args['type']}'),
                    Text('Amount: ${args['amount']}'),
                  ],
                ),
              ),
              onWillPop: () async {
                scaffoldState.currentState.hideCurrentSnackBar();
                return true;
              },
            );
          },
        );
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
  void dispose() {
    super.dispose();
    widget.callBack();
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
        title: Center(
          child: Text(
            "Saved",
            style: TextStyle(color: Colors.white),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () async {
              if (await rewardAd.isLoaded) {
                rewardAd.show();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => NewQRScreen()));
              } else {
                showSnackBar("Interstitial ad is still loading...");
              }
            },
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 1,
        color: Colors.black,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                child: Common.img != null && Common.img.length != 0
                    ? ListView.builder(
                        itemCount: Common.img.length,
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
                                  _showSimpleDialog(Common.img[index]);
                                },
                                leading: Container(
                                  color: Colors.white,
                                  child: QrImage(
                                    data: Common.img[index],
                                    version: QrVersions.auto,
                                    size: 50.0,
                                  ),
                                ),
                                title: Text(Common.img[index],
                                    style: TextStyle(color: Colors.white)),
                                trailing: Icon(
                                  Icons.more_vert,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.1,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left:
                                      MediaQuery.of(context).size.width * 0.05),
                              child: Text(
                                  "Please create a QR code to receive results",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20)),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.1,
                            ),
                            GestureDetector(
                              onTap: () async {
                                if (await rewardAd.isLoaded) {
                                  rewardAd.show();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => NewQRScreen()));
                                } else {
                                  showSnackBar(
                                      "Interstitial ad is still loading...");
                                }
                              },
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                width: MediaQuery.of(context).size.width * 0.5,
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text("Start create code",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
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

  void _showSimpleDialog(String ind) {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: <Widget>[
              ListTile(
                onTap: () {
                  _shareText(ind);
                },
                leading: Icon(Icons.share, color: Colors.grey),
                title: Text("Share"),
              ),
              ListTile(
                onTap: () {
                  removeValues(ind);
                  Navigator.of(context).pop();
                },
                leading: Icon(Icons.delete, color: Colors.grey),
                title: Text("Delete"),
              ),
            ],
          );
        });
  }
}
