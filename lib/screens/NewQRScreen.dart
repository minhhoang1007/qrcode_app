import 'package:admob_flutter/admob_flutter.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrcode_app/common/Common.dart';
import 'package:qrcode_app/config/ads.dart';
import 'package:qrcode_app/main.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NewQRScreen extends StatefulWidget {
  NewQRScreen({Key key}) : super(key: key);

  @override
  _NewQRScreenState createState() => _NewQRScreenState();
}

class _NewQRScreenState extends State<NewQRScreen> {
  var _controller = TextEditingController();
  GlobalKey _globalKey = GlobalKey();
  String hn;
  String textcode = "";
  AdmobBannerSize bannerSize;

  void initState() {
    bannerSize = AdmobBannerSize.MEDIUM_RECTANGLE;
    super.initState();
    hn = 'QRCode';
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void runSave() {
    if (Common.img == null) Common.img = [];
    Common.img.add(_controller.text);
    print("qwertyuiop");
    print(Common.img);
    prefs
        .setStringList(Common.LIST_TOW, Common.img)
        .then((onValue) {})
        .catchError((onError) {});
  }

  //share
  Future<void> _shareText() async {
    try {
      Share.text('ID Product: ', _controller.text, 'text/plain');
    } catch (e) {
      print('error: $e');
    }
  }

  @override
  void _showDialogNew() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Container(
              height: 300,
              width: 300,
              child: RepaintBoundary(
                key: _globalKey,
                child: QrImage(
                  data: _controller.text,
                  version: QrVersions.auto,
                  size: 200.0,
                ),
              ),
            ),
            content: Text("Create QR Code Successfully",
                style: TextStyle(
                    color: Colors.orange, fontWeight: FontWeight.bold)),
            actions: <Widget>[
              GestureDetector(
                onTap: () {
                  runSave();
                  Fluttertoast.showToast(
                      msg: "Save Image Code",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIos: 1,
                      backgroundColor: Colors.white,
                      textColor: Colors.orange,
                      fontSize: 16.0);
                  Navigator.of(context).pop();
                },
                child: Container(
                  height: 50,
                  width: 80,
                  decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(12)),
                  child: Center(
                    child: Text("Save",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _shareText();
                },
                child: Container(
                  height: 50,
                  width: 80,
                  decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(12)),
                  child: Center(
                    child: Text("Share",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                  ),
                ),
              ),
            ],
          );
        });
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
            "Create code",
            style: TextStyle(color: Colors.white),
          ),
        ),
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
                height: MediaQuery.of(context).size.height * 0.4,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black,
                ),
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
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(fontSize: 16),
                            border: InputBorder.none,
                            hintText: "Enter website, text,"
                                "email,....",
                            contentPadding: EdgeInsets.all(10),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.1),
                      child: GestureDetector(
                        onTap: () {
                          _showSimpleDialogHN();
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.05,
                          width: MediaQuery.of(context).size.width * 0.25,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                width: 5,
                              ),
                              Center(
                                  child: Text(hn,
                                      style: TextStyle(color: Colors.black))),
                              Icon(
                                Icons.arrow_drop_down,
                                color: Colors.orange,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.35),
                      child: GestureDetector(
                        onTap: () {
                          _controller.text == ""
                              ? Fluttertoast.showToast(
                                  msg: "Text Null",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIos: 1,
                                  backgroundColor: Colors.white,
                                  textColor: Colors.orange,
                                  fontSize: 16.0)
                              : _showDialogNew();
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.06,
                          width: MediaQuery.of(context).size.width * 0.3,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Center(
                            child: Text(
                              "Create",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                ),
                alignment: Alignment.center,
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

  void _showSimpleDialogHN() {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('Lựa chọn định dạng',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  this.setState(() {
                    hn = 'QRCode';
                  });
                  Navigator.pop(context);
                },
                child: const Text('QRCode'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  this.setState(() {
                    hn = 'Barcode';
                  });
                  Navigator.pop(context);
                },
                child: const Text('Barcode'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  this.setState(() {
                    hn = 'PDF 417';
                  });
                  Navigator.pop(context);
                },
                child: const Text('PDF 417'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  this.setState(() {
                    hn = 'Barcode-39';
                  });
                  Navigator.pop(context);
                },
                child: const Text('Barcode-39'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  this.setState(() {
                    hn = 'Barcode-93';
                  });
                  Navigator.pop(context);
                },
                child: const Text('Barcode-93'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  this.setState(() {
                    hn = 'AZTEC';
                  });
                  Navigator.pop(context);
                },
                child: const Text('AZTEC'),
              ),
            ],
          );
        });
  }
}
