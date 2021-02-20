import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:stall_noodle/base/base_state.dart';
import 'package:stall_noodle/common/custom_colors.dart';
import 'package:stall_noodle/common/dimens.dart';
import 'package:stall_noodle/common/image_path.dart';
import 'package:stall_noodle/common/strings.dart';
import 'package:stall_noodle/common/styles.dart';
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
              return _buildInputDialog(context);
            },
          );
        },
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Consumer<HomeProvider>(
          builder: (context, provider, child) {
            return _buildNoData();
          },
        ),
        /* child: ListView.builder(
          itemCount: 20,
          itemBuilder: (BuildContext context, int index) {
            return _buildItem(index);
          },
        ),*/
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
            children: [
              Text(
                "Stall Name",
                style: Style.ibmPleXSansRegular.copyWith(
                  color: CustomColors.topText283D3F,
                  fontSize: Dimens.standard_16,
                  letterSpacing: .25,
                  fontWeight: FontWeight.w500,
                ),
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
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimens.standard_8),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(16.0),
        margin: EdgeInsets.only(top: 16.0),
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                  color: Colors.black,
                  offset: Offset(0, 10),
                  blurRadius: 10,),
            ],),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "Hai Bro",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Lorem ipsum dollaro djsfndsakjnsa fdjsf",
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 22,
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Ok",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
