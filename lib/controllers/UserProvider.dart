import 'package:barvip_app/models/User.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  late Map<String, dynamic> user;

  userFromDb(User user) {
    user = user.toJson();
    notifyListeners();
  }
}
