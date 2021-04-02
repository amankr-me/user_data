import 'package:flutter/material.dart';
import 'package:user_data/provider/users.dart';
import 'package:provider/provider.dart';
import 'package:user_data/widgets/user_list.dart';
class UserScreen extends StatefulWidget {
  static const routeName = '/userscreen';

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    final userData =Provider.of<Users>(context);
    final users = userData.userLists;
    final itemCount = userData.userLists.length;
    return Scaffold(
      appBar: AppBar(title: Text('UsersList'),),
      body: ListView.builder(
        itemCount: itemCount,
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
    // create: (c) => products[i],
    value: users[i],
    child: UserList(),
    ),
    ),


    );
  }
}
