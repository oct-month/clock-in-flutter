import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import './Config.dart';
import './LoginPage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  GlobalKey _formKey = GlobalKey<FormState>();
  TextEditingController _scodeController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _classController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('注册'),
      ),
      body: Column(
        children: <Widget>[
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
                  TextFormField(
                    controller: _scodeController,
                    decoration: InputDecoration(
                      labelText: '学号',
                      hintText: '输入学号',
                      prefixIcon: Icon(Icons.school),
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    textAlign: TextAlign.left,
                    autofocus: true,
                    maxLines: 1,
                    validator: (value) {
                      return value!.trim().length > 0 ? null : "学号不能为空";
                    },
                  ),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: '姓名',
                      hintText: '输入姓名',
                      prefixIcon: Icon(Icons.person_add),
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    textAlign: TextAlign.left,
                    autofocus: true,
                    maxLines: 1,
                    validator: (value) {
                      return value!.trim().length > 0 ? null : "姓名不能为空";
                    },
                  ),
                  TextFormField(
                    controller: _classController,
                    decoration: InputDecoration(
                      labelText: '班级',
                      hintText: '输入班级',
                      prefixIcon: Icon(Icons.class_),
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    textAlign: TextAlign.left,
                    autofocus: true,
                    maxLines: 1,
                    validator: (value) {
                      return value!.trim().length > 0 ? null : "班级不能为空";
                    },
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _doRegister,
                      child: Text('注册'),
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

  void _doRegister() {
    if ((_formKey.currentState as FormState).validate()) {
      Dio().post(Config.BASE_URL + '/api/account/register', data: {
        "schoolCode": _scodeController.text.trim(),
        "name": _nameController.text.trim(),
        "className": _classController.text.trim(),
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return LoginPage();
              },
              maintainState: false,
            ),
          );
        }
      });
    }
  }
}
