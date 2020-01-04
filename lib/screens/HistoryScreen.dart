import 'package:flutter/material.dart';
import 'package:qrcode_app/common/Common.dart';
import 'package:qrcode_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryScreen extends StatefulWidget {
  HistoryScreen({Key key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  Future<Null> getString() async {
    Common.listhis = prefs.getStringList('list');
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
            child: Text("Lịch sử", style: TextStyle(color: Colors.white))),
        actions: <Widget>[
          GestureDetector(
            onTap: () {},
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
          color: Colors.black,
          child: Common.listhis.length != 0
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
                  child: Text("No data", style: TextStyle(color: Colors.white)),
                )),
    );
  }
}
