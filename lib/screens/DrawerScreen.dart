import 'package:flutter/material.dart';
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
                "Lịch sử",
                style: TextStyle(color: Colors.white),
              ),
            ),
            ListTile(
              onTap: () {
                _launchURL(urlNangcap);
              },
              leading: Icon(
                Icons.access_alarms,
                color: Colors.white,
              ),
              title: Text(
                "Nâng cấp phiên bản VIP",
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
                "Phản hồi cho nhà phát triển",
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
                "Kiểm tra phiên bản cập nhật",
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
                "Chính sách",
                style: TextStyle(color: Colors.white),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.card_giftcard,
                color: Colors.white,
              ),
              title: Text(
                "Ứng dụng khác",
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
