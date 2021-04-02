import 'package:flutter/material.dart';
class Success extends StatelessWidget {
  static const routeName = '/success';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Success'),),
      body: Center(child: Container(child: Text('Data Saved Successfully.'),),),
    );
  }
}
