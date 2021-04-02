import 'package:flutter/cupertino.dart';

class User with ChangeNotifier{
  final String id;
  final String name;
  final String gender;
  final DateTime dob;
  User({@required this.id,@required this.name, @required this.gender, @required this.dob,});
}