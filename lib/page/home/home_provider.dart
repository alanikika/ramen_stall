import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:stall_noodle/base/base_provider.dart';
import 'package:stall_noodle/common/req_id.dart';
import 'package:stall_noodle/common/strings.dart';
import 'package:stall_noodle/data/database_helper.dart';
import 'package:stall_noodle/util/validate_input.dart';

class HomeProvider extends BaseProvider {
  TextEditingController ramenNameController = TextEditingController();
  String ramenNameValidate;

  final dbHelper = DatabaseHelper.instance;

  validateInsertRamen(BuildContext context) async {
    String nameValidation =
        ValidateInput().validateRamenName(ramenNameController.text);

    if (nameValidation != null) {
      ramenNameValidate = nameValidation;
      notifyListeners();
    } else {
      int id = await performInsertRamenStall();
      if (id > 0) {
        listener.onSuccess(id, reqId: ReqIds.INSERT_RAMEN);
      } else {
        listener.onFailure(Strings.insertRamenFailed);
      }
    }
  }

  performInsertRamenStall() async {
    Map<String, dynamic> data = HashMap();
    data["name"] = ramenNameController.text;
    return await dbHelper.insertRamenStall(data);
  }

  performGetRamenStall() async {
    
  }
}