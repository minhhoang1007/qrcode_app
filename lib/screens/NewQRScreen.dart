import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrcode_app/common/Common.dart';
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void initState() {
    _controller.addListener(() {
      print("value: ${_controller.text}");
      setState(() {
        textcode = _controller.text;
      });
    });
    super.initState();
    hn = 'QRCode';
    Common.img = [];
  }

  Future<Null> saveQR() async {
    Common.img.add(textcode);
    return prefs.setStringList("listtwo", Common.img);
  }

  void runSave() {
    saveQR().then((value) {}, onError: (error) {
      print(error);
    });
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
            "Tạo mã",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Container(
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
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(fontSize: 16),
                    border: InputBorder.none,
                    hintText: "Nhập trang web, văn bản,"
                        "email hoặc tin nhắn của bạn ở đây",
                    contentPadding: EdgeInsets.all(10),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
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
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 5,
                      ),
                      Center(
                          child:
                              Text(hn, style: TextStyle(color: Colors.black))),
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
                  _showDialogNew();
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.3,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Center(
                    child: Text(
                      "Tạo mã",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ],
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
