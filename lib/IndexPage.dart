import 'package:flutter/material.dart';

import './QRViewPage.dart';
import './LoginPage.dart';
import './Utils.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  late Future<String> _schoolCode = Utils.getSchoolCode();

  @override
  void initState() {
    super.initState();
    _schoolCode.then((value) {
      if (value.isEmpty) {
        this._toLoginPage();
      }
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
          Image.asset(
            'assets/images/logo.jpg',
            fit: BoxFit.contain,
            alignment: Alignment.center,
          ),
          FutureBuilder(
            future: _schoolCode,
            builder: (context, snapshot) {
              return Text(
                snapshot.data as String,
                textAlign: TextAlign.right,
              );
            },
          ),
          Expanded(
            child: Column(
              children: [
                Spacer(
                  flex: 1,
                ),
                OutlinedButton(
                  style: ButtonStyle(
                    side: MaterialStateProperty.all(BorderSide.none),
                  ),
                  onPressed: _toScannPage,
                  child: Image.asset(
                    'assets/images/scaner.png',
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                  ),
                ),
                Spacer(
                  flex: 2,
                ),
              ],
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

  void _toLoginPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return LoginPage();
        },
        maintainState: true,
      ),
    );
  }
}
