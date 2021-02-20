import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:stall_noodle/common/custom_colors.dart';
import 'package:stall_noodle/common/dimens.dart';
import 'package:stall_noodle/common/image_path.dart';
import 'package:stall_noodle/common/styles.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title, imageLeft, imageRight;
  final bool backFlag;
  final VoidCallback onClickLeftImage, onClickRightImage;
  final Color backgroundColor, imageLeftColor, imageRightColor, titleColor;
  final TextStyle textStyle;
  final List<Widget> action;
  final double elevation;

  CustomAppBar({
    this.title,
    this.imageLeft,
    this.imageRight,
    this.backFlag = false,
    this.onClickLeftImage,
    this.onClickRightImage,
    this.backgroundColor,
    this.imageLeftColor,
    this.imageRightColor,
    this.titleColor = CustomColors.appBarText153639,
    this.textStyle,
    this.action,
    this.elevation = 0.0
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AppBar(
        elevation: elevation,
        automaticallyImplyLeading: backFlag,
        backgroundColor: backgroundColor ?? CustomColors.whiteFFFFFF,
        brightness: Brightness.dark,
        leading: backFlag
            ? InkWell(
                onTap: () => onClickLeftImage == null
                    ? Navigator.pop(context)
                    : onClickLeftImage(),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: Dimens.standard_28),
                      child: Image.asset(
                        imageLeft == null ? ImagePath.back : imageLeft,
                        color: imageLeftColor == null
                            ? CustomColors.topText283D3F
                            : imageLeftColor,
                        height: Dimens.standard_16,
                        width: Dimens.standard_16,
                      ),
                    ),
                  ],
                ),
              )
            : null,
        actions: [
          imageRight != null
              ? Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                        right: Dimens.standard_20,
                      ),
                      child: InkWell(
                        onTap: () => onClickRightImage(),
                        child: Padding(
                          padding: EdgeInsets.all(Dimens.standard_8),
                          child: Image.asset(
                            imageRight,
                            color: imageRightColor == null
                                ? CustomColors.whiteFFFFFF
                                : imageRightColor,
                            height: Dimens.standard_16,
                            width: Dimens.standard_16,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : SizedBox(),
        ],
        title: Text(
          title,
          style: textStyle ??
              Style.ibmPleXSansBold.copyWith(
                fontSize: Dimens.standard_16,
                color: titleColor,
                fontWeight: FontWeight.w500,
                letterSpacing: .15,
              ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
