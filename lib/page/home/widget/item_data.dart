import 'package:flutter/material.dart';
import 'package:stall_noodle/common/custom_colors.dart';
import 'package:stall_noodle/common/dimens.dart';
import 'package:stall_noodle/common/image_path.dart';
import 'package:stall_noodle/common/styles.dart';
import 'package:stall_noodle/page/home/home_provider.dart';

class ItemData extends StatelessWidget {
  const ItemData({
    @required HomeProvider homeProvider,
    @required int index,
  })  : _homeProvider = homeProvider,
        index = index;

  final HomeProvider _homeProvider;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: Dimens.standard_16,
          ),
          height: Dimens.standard_48,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _homeProvider.getRamenData[index].name,
                style: Style.ibmPleXSansRegular.copyWith(
                  color: CustomColors.topText283D3F,
                  fontSize: Dimens.standard_16,
                  letterSpacing: .25,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Image.asset(
                ImagePath.next,
                height: Dimens.standard_12,
                width: Dimens.standard_12,
                color: CustomColors.neutral20E3033.withOpacity(.5),
              )
            ],
          ),
        ),
        Divider(
          height: Dimens.standard_0,
          thickness: 1.0,
        )
      ],
    );
  }
}
