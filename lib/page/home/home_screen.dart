import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:stall_noodle/base/base_state.dart';
import 'package:stall_noodle/common/custom_colors.dart';
import 'package:stall_noodle/common/dimens.dart';
import 'package:stall_noodle/common/image_path.dart';
import 'package:stall_noodle/common/req_id.dart';
import 'package:stall_noodle/common/routes.dart';
import 'package:stall_noodle/common/strings.dart';
import 'package:stall_noodle/common/styles.dart';
import 'package:stall_noodle/model/ramen_model.dart';
import 'package:stall_noodle/page/home/home_provider.dart';
import 'package:stall_noodle/page/home/widget/empty_state.dart';
import 'package:stall_noodle/page/home/widget/item_data.dart';
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
      ProgressBar.instance.showProgressbarWithContext(context);
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
                      return ItemData(
                        homeProvider: _homeProvider,
                        index: index,
                      );
                    },
                  )
                : EmptyState();
          },
        ),
      ),
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
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
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
  void onSuccess(any, {int reqId}) async {
    ProgressBar.instance.hideProgressBar();
    switch (reqId) {
      case ReqIds.GET_RAMEN:
        List<RamenModel> data = any as List<RamenModel>;
        _homeProvider.setRamenStallData(data);
        break;
      case ReqIds.INSERT_RAMEN:
        int id = any as int;
        await Navigator.popAndPushNamed(
          context,
          Routes.detail,
          arguments: id,
        );
        break;
    }
    super.onSuccess(any);
  }
}
