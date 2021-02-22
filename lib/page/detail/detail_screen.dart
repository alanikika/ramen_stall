import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  final int id;

  const DetailScreen({this.id});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      left: false,
      right: false,
      child: Container(),
    );
  }
}
