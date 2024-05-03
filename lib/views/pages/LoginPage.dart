import 'package:barvip_app/controllers/BaseController.dart';

import 'package:barvip_app/utils/MyColors.dart';

import 'package:barvip_app/views/pages/LobbyPage.dart';
import 'package:barvip_app/views/pages/RegisterPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _passwordVisible = true;
  BaseController _baseController = BaseController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
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
                Form(key: _formKey, child: FormWidgets())
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
                        TextButton(
                            onPressed: () {},
                            child: Text(
                              'Don\'t have an account yet?',
                              style: TextStyle(color: MyColors.SecondaryColor),
                            )),
                        OutlinedButton(
                            style: ButtonStyle(
                              side: MaterialStateProperty.all(
                                  BorderSide(color: MyColors.ButtonColor)),
                              minimumSize: MaterialStateProperty.all(Size(
                                  MediaQuery.of(context).size.width * 0.8, 40)),
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
      ),
    );
  }

  Column FormWidgets() {
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
              height: 50, width: double.infinity, child: SignInButton()),
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

  ElevatedButton SignInButton() {
    return ElevatedButton(
      onPressed: () {
        // Se valida el email y la contrasena ingresada
        String? validationResult = _baseController.validateFieldLogin(
            _emailController.text, _passwordController.text);
        //Si validation result es null, quiere decir que los campos estan correctamente diligenciados

        if (validationResult == null) {
          _baseController.loginFirebase(
              _emailController.text, _passwordController.text, context);
        } else {
          //si no, se muestra un snackbar con el mensaje de error, correspondiente.
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                validationResult,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w700),
              )));
        }
      },
      child: Text(
        'Sign In',
        style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w400,
            letterSpacing: 0),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: MyColors.ButtonColor,
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
