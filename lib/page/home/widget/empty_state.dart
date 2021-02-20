
import 'package:flutter/material.dart';
import 'package:stall_noodle/common/custom_colors.dart';
import 'package:stall_noodle/common/dimens.dart';
import 'package:stall_noodle/common/image_path.dart';
import 'package:stall_noodle/common/strings.dart';
import 'package:stall_noodle/common/styles.dart';

class EmptyState extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          ImagePath.noData,
          height: Dimens.standard_240,
          width: Dimens.standard_240,
        ),
        SizedBox(
          height: Dimens.standard_8,
        ),
        Text(
          Strings.noData,
          style: Style.ibmPleXSansRegular.copyWith(
            color: CustomColors.topText283D3F,
            fontSize: Dimens.standard_24,
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    );
  }
}