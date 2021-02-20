import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stall_noodle/common/custom_colors.dart';
import 'package:stall_noodle/common/strings.dart';
import 'package:stall_noodle/page/home/home_provider.dart';
import 'package:stall_noodle/page/home/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => HomeProvider(),
        ),
      ],
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: MaterialApp(
          title: Strings.appName,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: CustomColors.primaryColor,
            primaryColorDark: CustomColors.primaryColor,
            primaryColorLight: CustomColors.primaryColor,
            accentColor: CustomColors.primaryColor,
          ),
          home: SafeArea(
            left: false,
            right: false,
            child: HomeScreen(),
          ),
        ),
      ),
    );
  }
}
