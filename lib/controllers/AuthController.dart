import 'package:barvip_app/controllers/UserController.dart';
import 'package:barvip_app/controllers/UserProvider.dart';
import 'package:barvip_app/models/User.dart';
import 'package:barvip_app/utils/MyStyles.dart';
import 'package:barvip_app/views/pages/DashBoardBarberPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class authController {
  UserController _userController = UserController();
  MyStyles myStyles = MyStyles();

  void loginGoogle(
    UserCredential credential,
    BuildContext context,
    UserProvider userProvider,
  ) async {
    String? fullName = credential.user?.displayName;
    List<String>? nameParts = fullName?.split(' ');
    UserBarvip newUser = UserBarvip(
      name: nameParts?.first ?? 'Default Name',
      lastName: nameParts != null && nameParts.length > 1
          ? nameParts.last
          : 'Default Last Name',
      email: credential.user?.email ?? 'default@email.com',
      password: "undefined",
      typeUser: "client",
      urlImage: credential.user?.photoURL ?? 'default_image_url',
    );

    var existingUser = await _userController.getUserByEmail(newUser.email);

    if (existingUser == false) {
      userProvider.userFromDb(newUser);
      await _userController.saveData(newUser.toJson());
      ScaffoldMessenger.of(context).showSnackBar(
        myStyles.snackbar(
            "Welcome ${newUser.name} ${newUser.lastName}", Colors.green),
      );
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => DashBoardBarberPage(),
      ));
      return;
    } else {
      userProvider.userFromDb(newUser);
      print("Welcome ${newUser.name} ${newUser.lastName}");
      ScaffoldMessenger.of(context).showSnackBar(
        myStyles.snackbar(
            "Welcome ${newUser.name} ${newUser.lastName}", Colors.green),
      );
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => DashBoardBarberPage(),
      ));
    }
  }
}
