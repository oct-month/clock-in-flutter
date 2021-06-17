import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './Config.dart';
import './IndexPage.dart';
import './RegisterPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _controller = TextEditingController();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<bool> _setSchoolCode(String schoolCode) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.setString('school_code', schoolCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('登录'),
      ),
      body: Column(
        children: <Widget>[
          Image.asset(
            'assets/images/logo.jpg',
            fit: BoxFit.contain,
            alignment: Alignment.center,
          ),
          Expanded(
            child: Column(
              children: [
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText: '学号',
                    hintText: '输入学号',
                    prefixIcon: Icon(Icons.school),
                  ),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  textAlign: TextAlign.left,
                  autofocus: true,
                  maxLines: 1,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _doLogin,
                    child: Text('登录'),
                  ),
                ),
                TextButton(
                  onPressed: _toRegisterPage,
                  child: Text('没有账号？去注册...'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _doLogin() {
    String schoolCode = this._controller.text.trim();
    Dio().post(Config.BASE_URL + '/api/account/login', data: {
      "schoolCode": schoolCode,
    }).then((resp) {
      var data = jsonDecode(resp.data.toString());
      Fluttertoast.showToast(
        msg: data['msg'].toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 16.0,
      );
      if (data['status'].toString() == 'success') {
        this._setSchoolCode(schoolCode).then((success) {
          if (success) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return IndexPage();
                },
                maintainState: false,
              ),
            );
          } else {
            Fluttertoast.showToast(
              msg: '无法读写存储',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.white,
              textColor: Colors.black,
              fontSize: 16.0,
            );
          }
        });
      }
    });
  }

  void _toRegisterPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return RegisterPage();
        },
        maintainState: false,
      ),
    );
  }
}
