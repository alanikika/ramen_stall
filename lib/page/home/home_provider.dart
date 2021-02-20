import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:stall_noodle/base/base_provider.dart';
import 'package:stall_noodle/common/req_id.dart';
import 'package:stall_noodle/common/strings.dart';
import 'package:stall_noodle/data/database_helper.dart';
import 'package:stall_noodle/model/ramen_model.dart';
import 'package:stall_noodle/util/validate_input.dart';

class HomeProvider extends BaseProvider {
  TextEditingController ramenNameController = TextEditingController();
  String ramenNameValidate;
  List<RamenModel> _ramenData;

  final dbHelper = DatabaseHelper.instance;

  validateInsertRamen() async {
    String nameValidation =
        ValidateInput().validateRamenName(ramenNameController.text);

    if (nameValidation != null) {
      ramenNameValidate = nameValidation;
      notifyListeners();
    } else {
      int id = await performInsertRamenStall();
      if (id > 0) {
        RamenModel _model = RamenModel();
        _model.name = ramenNameController.text;
        _ramenData.add(_model);

        ramenNameController.clear();

        listener.onSuccess(id, reqId: ReqIds.INSERT_RAMEN);
      } else {
        listener.onFailure(Strings.insertRamenFailed);
      }
    }
  }

  performInsertRamenStall() async {
    bool isExist = await getRamenByName();
    if (!isExist) {
      Map<String, dynamic> data = HashMap();
      data["name"] = ramenNameController.text;
      return await dbHelper.insertRamenStall(data);
    } else {
      ramenNameValidate = "Ramen stall name already exist";
      notifyListeners();
    }
  }

  Future<bool> getRamenByName() async {
    return await dbHelper.isRamenExist(ramenNameController.text);
  }

  clearError() {
    if (ramenNameValidate != null) {
      ramenNameValidate = null;
    }
  }

  performGetRamenStall() async {
    try {
      List<RamenModel> data = await dbHelper.getRamenStall();
      listener.onSuccess(data, reqId: ReqIds.GET_RAMEN);
    } catch (e) {
      listener.onFailure(Strings.getDataFailed);
    }
  }

  setRamenStallData(List<RamenModel> data) {
    _ramenData = data;
    notifyListeners();
  }

  List<RamenModel> get getRamenData => _ramenData;
}
