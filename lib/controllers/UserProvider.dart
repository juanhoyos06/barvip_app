import 'package:barvip_app/models/User.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  late Map<String, dynamic> users;

  userFromDb(UserBarvip user) {
    users = user.toJson();
    notifyListeners();
  }
}
