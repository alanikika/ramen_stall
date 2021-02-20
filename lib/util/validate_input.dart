import 'package:stall_noodle/common/strings.dart';

class ValidateInput {
  String validateRamenName(String value) {
    if(value.isEmpty) {
      return Strings.ramenMustBeFilled;
    }
    return null;
  }
}