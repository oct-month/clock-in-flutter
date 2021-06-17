import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import './Config.dart';
import './IndexPage.dart';
import './RegisterPage.dart';
import './Utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey _formKey = GlobalKey<FormState>();
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('登录'),
      ),
      body: Column(
        children: [
          Image.asset(
            'assets/images/logo.jpg',
            fit: BoxFit.contain,
            alignment: Alignment.center,
          ),
          Expanded(
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: [
                        TextFormField(
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
                          validator: (value) {
                            return value!.trim().length > 0 ? null : "学号不能为空";
                          },
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
            ),
          ),
        ],
      ),
    );
  }

  void _doLogin() {
    if ((_formKey.currentState as FormState).validate()) {
      String schoolCode = this._controller.text.trim();
      Dio().post(Config.BASE_URL + '/api/account/login', data: {
        "schoolCode": schoolCode,
      }).then((resp) {
        var data = resp.data;
        Fluttertoast.showToast(
          msg: data['msg'].toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0,
        );
        if (data['status'].toString() == Config.SUCCESS) {
          Utils.setSchoolCode(schoolCode).then((success) {
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
