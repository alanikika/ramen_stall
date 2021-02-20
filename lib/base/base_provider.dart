import 'package:flutter/material.dart';
import 'package:stall_noodle/base/base_model.dart';
import 'package:stall_noodle/base/callback_listener.dart';
abstract class BaseProvider<T extends BaseModel> with ChangeNotifier
{
  OnCallbackListener listener;

  @override
  void dispose() {
    super.dispose();
  }
}