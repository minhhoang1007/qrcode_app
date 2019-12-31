import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryScreen extends StatefulWidget {
  HistoryScreen({Key key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String his = "";
  Future<Null> getString() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    his = prefs.getString('name');
  }

  List<String> items = [
    "abc",
    "acb",
    "bca",
  ];
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
          IconButton(
            icon: Icon(Icons.ac_unit),
            iconSize: 30,
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        color: Colors.black,
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, int index) {
            return Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.05,
                right: MediaQuery.of(context).size.width * 0.05,
              ),
              child: Card(
                color: Colors.grey,
                child: ListTile(
                  title:
                      Text(items[index], style: TextStyle(color: Colors.white)),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
