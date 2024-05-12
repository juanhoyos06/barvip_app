import 'package:barvip_app/controllers/UserController.dart';
import 'package:barvip_app/controllers/UserProvider.dart';
import 'package:barvip_app/models/User.dart';
import 'package:barvip_app/utils/MyStyles.dart';
import 'package:barvip_app/views/pages/DashBoardBarberPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:barvip_app/models/User.dart';

class authController {
  UserController _userController = UserController();
  MyStyles myStyles = MyStyles();
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  void loginGoogle(
    auth.UserCredential credential,
    BuildContext context,
    UserProvider userProvider,
  ) async {
    String? fullName = credential.user?.displayName;
    List<String>? nameParts = fullName?.split(' ');
    User newUser = User(
      id: credential.user!.uid,
      name: nameParts?.first ?? 'Default Name',
      lastName: nameParts != null && nameParts.length > 1
          ? nameParts.last
          : 'Default Last Name',
      email: credential.user?.email ?? 'default@email.com',
      password: "undefined",
      typeUser: "client",
      urlImage: credential.user?.photoURL ?? 'default_image_url',
    );

    final Map<String, dynamic> existingUser =
        await _userController.getUserByEmail(newUser.email);

    if (existingUser['success'] == false) {
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
      User newUser = User(
        id: existingUser['data']['id'],
        name: existingUser['data']['name'],
        lastName: existingUser['data']['lastName'],
        email: existingUser['data']['email'],
        password: existingUser['data']['password'],
        typeUser: existingUser['data']['typeUser'],
        urlImage: existingUser['data']['urlImage'],
      );
      var name = existingUser['data']['name'];
      var lastName = existingUser['data']['lastName'];
      userProvider.userFromDb(newUser);
      print("Welcome ${name} ${lastName}");
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
