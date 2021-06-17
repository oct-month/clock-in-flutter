import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './QRViewPage.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<String> _schoolCode;

  Future<void> _setSchoolCode(String schoolCode) async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      _schoolCode =
          prefs.setString('school_code', schoolCode).then((bool success) {
        if (success) {
          return schoolCode;
        } else {
          return _schoolCode;
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _schoolCode = _prefs.then((SharedPreferences prefs) {
      return (prefs.getString('school_code') ?? '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('自习室打卡'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Image.asset(
              'assets/images/logo.jpg',
              fit: BoxFit.contain,
              alignment: Alignment.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: FutureBuilder(
              future: _schoolCode,
              builder: (context, snapshot) {
                return Text(
                  snapshot.data as String,
                  textAlign: TextAlign.right,
                );
              },
            ),
          ),
          Expanded(
            flex: 4,
            child: ElevatedButton(
              onPressed: _toScannPage,
              child: Image.asset(
                'assets/images/scaner.png',
                fit: BoxFit.contain,
                alignment: Alignment.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _toScannPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return QRViewPage();
        },
        maintainState: true,
      ),
    );
  }
}
