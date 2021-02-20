import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:stall_noodle/base/base_state.dart';
import 'package:stall_noodle/common/custom_colors.dart';
import 'package:stall_noodle/common/dimens.dart';
import 'package:stall_noodle/common/image_path.dart';
import 'package:stall_noodle/common/req_id.dart';
import 'package:stall_noodle/common/strings.dart';
import 'package:stall_noodle/common/styles.dart';
import 'package:stall_noodle/model/ramen_model.dart';
import 'package:stall_noodle/page/home/home_provider.dart';
import 'package:stall_noodle/widget/custom_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:stall_noodle/widget/progressbar.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseState<HomeScreen> {
  HomeProvider _homeProvider;

  @override
  void initState() {
    _homeProvider = Provider.of<HomeProvider>(context, listen: false);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      // ProgressBar.instance.showProgressbarWithContext(context);
      _homeProvider.listener = this;
      _homeProvider.performGetRamenStall();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.whiteFFFFFF,
      appBar: CustomAppBar(
        title: Strings.appName,
        imageRight: ImagePath.plus,
        imageRightColor: CustomColors.colorOrangeF7931D,
        onClickRightImage: () async {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              _homeProvider.clearError();
              return _buildInputDialog(context);
            },
          );
        },
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Consumer<HomeProvider>(
          builder: (context, provider, child) {
            return provider.getRamenData != null
                ? ListView.builder(
                    itemCount: provider.getRamenData.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _buildItem(index);
                    },
                  )
                : _buildNoData();
          },
        ),
      ),
    );
  }

  Widget _buildItem(int index) {
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

  //Show this widget when data is empty
  Widget _buildNoData() {
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

  //Input dialog
  Widget _buildInputDialog(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimens.standard_4),
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(Dimens.standard_16),
            decoration: BoxDecoration(
              color: CustomColors.whiteFFFFFF,
              borderRadius: BorderRadius.circular(Dimens.standard_16),
              boxShadow: [
                BoxShadow(
                  color: CustomColors.neutral20E3033.withOpacity(.5),
                  offset: Offset(5.0, 10.0),
                  blurRadius: 5.0,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                TextField(
                  controller: _homeProvider.ramenNameController,
                  decoration: InputDecoration(
                    labelText: Strings.ramenStallName,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: CustomColors.colorOrangeF7931D,
                      ),
                    ),
                    errorText: _homeProvider.ramenNameValidate,
                  ),
                ),
                SizedBox(
                  height: Dimens.standard_8,
                ),
                RaisedButton(
                  onPressed: () {
                    _homeProvider.validateInsertRamen();
                  },
                  color: CustomColors.colorOrangeF7931D,
                  child: Text(
                    Strings.add,
                    style: Style.ibmPleXSansMedium.copyWith(
                      color: CustomColors.whiteFFFFFF,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void onSuccess(any, {int reqId}) {
    ProgressBar.instance.hideProgressBar();
    switch (reqId) {
      case ReqIds.GET_RAMEN:
        List<RamenModel> data = any as List<RamenModel>;
        _homeProvider.setRamenStallData(data);
        break;
      case ReqIds.INSERT_RAMEN:
        Navigator.pop(context);
        debugPrint("insert success");
        break;
    }
    super.onSuccess(any);
  }
}
