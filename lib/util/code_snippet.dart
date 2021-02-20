import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CodeSnippet {
  static final CodeSnippet _singleton = new CodeSnippet._internal();

  CodeSnippet._internal();

  static CodeSnippet get instance => _singleton;

  showAlertMsg(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      backgroundColor: Colors.red[400],
      textColor: Colors.white,
    );
  }
}
