import 'package:flutter/material.dart';
import 'package:stall_noodle/util/code_snippet.dart';
import 'package:stall_noodle/widget/progressbar.dart';
class ErrorHandling
{
  static void errorValidation(BuildContext context, String response) {
    ProgressBar.instance.hideProgressBar();
    CodeSnippet.instance.showAlertMsg(response);
  }
}