import 'dart:ui';

import 'package:barvip_app/controllers/AuthController.dart';
import 'package:barvip_app/controllers/Services.dart';
import 'package:barvip_app/controllers/UserController.dart';
import 'package:barvip_app/controllers/UserProvider.dart';
import 'package:barvip_app/utils/MyColors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:barvip_app/views/pages/LobbyPage.dart';
import 'package:barvip_app/views/pages/RegisterPage.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);
  bool _passwordVisible = true;
  UserController _userController = UserController();
  authController _authController = authController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final UserProvider _userProvider = UserProvider();
  String? name = "";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: Colors.black,
        body: ValueListenableBuilder(
            valueListenable: _isLoading,
            builder: (context, isLoading, _) {
              if (isLoading) {
                return Center(
                  child: Stack(
                    children: [
                      LoginPage(context),
                      BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                        child: Container(
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: LoadingAnimationWidget.inkDrop(
                            color: Colors.white, size: 50),
                      ),
                    ],
                  ),
                );
              } else {
                return LoginPage(context);
              }
            }));
  }

  Consumer<UserProvider> LoginPage(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (_, userProvider, child) {
        return Container(
          margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.08,
              vertical: MediaQuery.of(context).size.height * 0.1),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: MyColors.TextInputColor,
                      ),
                      child: IconButton(
                          iconSize: 20,
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => LobbyPage(),
                            ));
                          },
                          icon: const Icon(
                            Icons.keyboard_arrow_left,
                            color: Colors.white,
                          ))),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                    child: Text(
                      'Sign In',
                      style: GoogleFonts.sora(
                          color: Colors.white,
                          fontSize: 42,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0),
                    ),
                  ),
                  Form(key: _formKey, child: FormWidgets(userProvider))
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                          color: MyColors.TextInputColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          )),
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.13,
                      child: Column(
                        children: [
                          Text(
                            'Don\'t have an account yet?',
                            style: TextStyle(
                                color: MyColors.SecondaryColor,
                                height: MediaQuery.of(context).size.height *
                                    0.0035),
                          ),
                          OutlinedButton(
                              style: ButtonStyle(
                                side: MaterialStateProperty.all(
                                    BorderSide(color: MyColors.ButtonColor)),
                                minimumSize: MaterialStateProperty.all(Size(
                                    MediaQuery.of(context).size.width * 0.8,
                                    40)),
                                backgroundColor: MaterialStateProperty.all(
                                    MyColors.ButtonColor),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => RegisterPage(),
                                ));
                              },
                              child: Text(
                                'Create Account',
                                style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0),
                              ))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Column FormWidgets(UserProvider userProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
          child: Text(
            'Email',
            style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w400,
                letterSpacing: 0),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Container(
            height: 50,
            child: EmailTextFormField(),
          ),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
          child: Text(
            'Password',
            style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w400,
                letterSpacing: 0),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Container(
            height: 50,
            child: PasswordTextFormField(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
          child: Container(
              height: 50,
              width: double.infinity,
              child: SignInButton(userProvider)),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
          child: Container(
              height: 50,
              width: double.infinity,
              child: SignInButtonGoogle(userProvider)),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 14, 0, 0),
            child: TextButton(
                onPressed: () {},
                child: Text(
                  'I don\'t remember my password',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0,
                  ),
                )),
          ),
        ),
      ],
    );
  }

  ElevatedButton SignInButton(UserProvider userProvider) {
    return ElevatedButton(
      onPressed: () async {
        _isLoading.value = true;

        // Se valida el email y la contrasena ingresada
        await _userController.validateFieldLogin(_emailController.text,
            _passwordController.text, context, userProvider);
        // Se usa future para esperar a que se valide el email y la contrasena y posteriormente realice el inicio de sesion antes de terminar de mostrar la animacion de carga
        _isLoading.value = false;
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: MyColors.ButtonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      child: Text(
        'Sign In',
        style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w400,
            letterSpacing: 0),
      ),
    );
  }

  ElevatedButton SignInButtonGoogle(UserProvider userProvider) {
    return ElevatedButton.icon(
      label: Text(
        'Sign In With Google',
        style: GoogleFonts.inter(
            color: Colors.black54,
            fontSize: 18,
            fontWeight: FontWeight.w500,
            letterSpacing: 0),
      ),
      icon: Image.network(
          "https://cdn1.iconfinder.com/data/icons/google-s-logo/150/Google_Icons-09-512.png"),
      onPressed: () async {
        _isLoading.value = true;
        // Se valida el email y la contrasena ingresada
        auth.UserCredential credential = await signInWithGoogle();
        await _authController.loginGoogle(credential, context, userProvider);
        setState(() {
          name = credential.user?.displayName;
        });
        _isLoading.value = false;
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    );
  }

  TextFormField PasswordTextFormField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _passwordVisible,
      decoration: InputDecoration(
        suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
            icon: Icon(
              _passwordVisible ? Icons.visibility_off : Icons.visibility,
              color: MyColors.SecondaryColor,
            )),
        fillColor: MyColors.TextInputColor,
        filled: true,
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color(0x00000000),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 28, 33, 39),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      style: TextStyle(
          fontFamily: GoogleFonts.inter().fontFamily, color: Colors.white),
    );
  }

  TextFormField EmailTextFormField() {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        fillColor: MyColors.TextInputColor,
        filled: true,
        enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color(0x00000000),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 28, 33, 39),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      style: TextStyle(
          fontFamily: GoogleFonts.inter().fontFamily, color: Colors.white),
    );
  }
}
