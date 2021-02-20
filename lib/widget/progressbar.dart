import 'package:flutter/material.dart';
import 'package:stall_noodle/common/custom_colors.dart';
import 'package:stall_noodle/common/dimens.dart';

class ProgressBar {
  BuildContext _context;

  static final ProgressBar _progressbar = ProgressBar._internal();

  factory ProgressBar() {
    return _progressbar;
  }

  ProgressBar._internal();

  static ProgressBar get instance => _progressbar;

  bool _isShowing;

  void setContext(BuildContext context) {
    if (context != null) this._context = context;
  }

  void showProgressbar() {
    _isShowing = true;
    showDialog(
      context: _context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: Center(child: CircularProgressIndicator()));
      },
    );
  }

  void showProgressbarWithContext(BuildContext context) {
    this._context = context;
    _isShowing = true;
    showDialog(
      context: _context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () {
            return Future.value(false);
          },
          child: Center(
            child: Material(
              borderRadius:
                  BorderRadius.all(Radius.circular(Dimens.standard_5)),
              color: CustomColors.whiteFFFFFF,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Dimens.standard_15,
                    vertical: Dimens.standard_15),
                child: Container(
                  width: Dimens.standard_15,
                  height: Dimens.standard_15,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      CustomColors.colorA1AAAB,
                    ),
                    strokeWidth: Dimens.standard_2,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void hideProgressBar() {
    if (_isShowing != null && _context != null && _isShowing) {
      Navigator.pop(_context);
      _isShowing = false;
    }
  }
}
