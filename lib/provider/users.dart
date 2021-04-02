import 'package:flutter/foundation.dart';
import 'package:user_data/provider/user.dart';
import 'dart:math';

class Users with ChangeNotifier{
  List<User> _userList = [
    User(id:'id1',name: 'AB', gender: 'Male', dob: DateTime(1997)),
    User(id:'id2',name: 'CD', gender: 'Male', dob: DateTime(1993)),
    User(id:'id3',name: 'EF', gender: 'Female', dob: DateTime(1999)),
  ];
  List<User> get userLists {
    return [..._userList];

  }
  Future<void> addUser(User user) async {
    Random random = new Random();
    int randomNumber = random.nextInt(1000);
    try {
      final newUser = User(
        name: user.name,
        gender: user.gender,
        dob: user.dob,
        id: randomNumber.toString(),
      );
      _userList.add(newUser);
      // _items.add(value);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

}