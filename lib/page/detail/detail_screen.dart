import 'package:flutter/material.dart';
import 'package:stall_noodle/common/strings.dart';
import 'package:stall_noodle/widget/custom_app_bar.dart';

class DetailScreen extends StatefulWidget {
  final int id;

  const DetailScreen({this.id});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backFlag: true,
        title: Strings.ramenStallTracker,
      ),
      body: SafeArea(
        left: false,
        right: false,
        child: Container(),
      ),
    );
  }
}
