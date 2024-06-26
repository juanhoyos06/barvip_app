// ignore_for_file: unrelated_type_equality_checks

import 'dart:ffi';
import 'dart:io';
import 'dart:ui';

import 'package:barvip_app/controllers/UserController.dart';
import 'package:barvip_app/views/pages/LobbyPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:barvip_app/views/pages/LoginPage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //Variables declaration
  String? dropdownValue;
  File? imageUpload;

  ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);

  //Controller declaration
  final typeController = TextEditingController();
  UserController _userController = UserController();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirpasswordController = TextEditingController();

  //keys declarations
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      body: ValueListenableBuilder(
          valueListenable: _isLoading,
          builder: (context, isLoading, _) {
            if (isLoading) {
              return Center(
                child: Stack(
                  children: [
                    RegisterPage(context),
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
              return RegisterPage(context);
            }
          }),
    );
  }

  SingleChildScrollView RegisterPage(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.08,
            vertical: MediaQuery.of(context).size.height * 0.1),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Color.fromARGB(255, 28, 33, 39),
                ),
                child: IconButton(
                    iconSize: 20,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.keyboard_arrow_left,
                      color: Colors.white,
                    ))),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
              child: Text(
                'Create an account',
                style: GoogleFonts.sora(
                    color: Colors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0),
              ),
            ),
            FormsFieldsRegister()
          ],
        ),
      ),
    );
  }

  Form FormsFieldsRegister() {
    return Form(
      key: _key,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 18, 0, 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: image()),
                buildTextField(
                    controller: nameController,
                    labelText: "Name",
                    isPassword: false,
                    validatorField: _userController.validateName),
                buildTextField(
                    controller: lastNameController,
                    labelText: "Last Name",
                    isPassword: false,
                    validatorField: _userController.validateName),
                buildTextField(
                    controller: emailController,
                    labelText: "Email",
                    isPassword: false,
                    validatorField: _userController.validateEmail),
                buildTextField(
                    controller: passwordController,
                    labelText: "Password",
                    isPassword: true,
                    validatorField: (value) =>
                        _userController.validateFieldAndPassword(
                            value, confirpasswordController)),
                buildTextField(
                    controller: confirpasswordController,
                    labelText: "Confirm Password",
                    isPassword: true,
                    validatorField: (value) => _userController
                        .validateFieldAndPassword(value, passwordController)),
                textFieldType(),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                      height: 50,
                      width: double.infinity,
                      child: RegisterButton(_key)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget image() {
    return GestureDetector(
      onTap: () async {
        final imagen = await _userController.getImage();
        if (imagen != null) {
          setState(() {
            imageUpload = File(imagen.path);
          });
        } else {
          setState(() {});
        }
      },
      child: CircleAvatar(
        backgroundImage: imageUpload != null
            ? FileImage(imageUpload!)
            : const AssetImage('lib/assets/images/user_profile.png')
                as ImageProvider,
        radius: 60,
        backgroundColor: Colors.grey[200],
      ),
    );
  }

  Padding buildTextField({
    required TextEditingController controller,
    required String labelText,
    bool isPassword = false,
    required validatorField,
  }) {
    bool _obscureText = isPassword;
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0, 18, 0, 0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          paddingForms(labelText),
          StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return TextFormField(
              style: const TextStyle(color: Colors.white),
              controller: controller,
              validator: validatorField,
              obscureText: _obscureText,
              decoration: InputDecoration(
                fillColor: Color.fromARGB(255, 28, 33, 39),
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
                suffixIcon: isPassword
                    ? IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () => setState(() {
                          _obscureText = !_obscureText;
                        }),
                      )
                    : null,
              ),
            );
          }),
        ],
      ),
    );
  }

//Decoraccion de los fields
  InputDecoration decorationFields() {
    return InputDecoration(
      fillColor: Color.fromARGB(255, 28, 33, 39),
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
    );
  }

//Pading de los fields
  Padding paddingForms(String labelText) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
      child: Text(
        labelText,
        style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w400,
            letterSpacing: 0),
      ),
    );
  }

  textFieldType() {
    return Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0, 18, 0, 10),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            paddingForms("Type"),
            Container(
              width: double.infinity,
              child: Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: Colors
                      .black, // Esto cambiará el color de fondo de la lista desplegable a negro
                  textTheme: TextTheme(
                    subtitle1: TextStyle(color: Colors.white),
                  ),
                ),
                child: DropdownButtonFormField<String>(
                  isExpanded: true,
                  decoration: decorationFields(),
                  style: TextStyle(
                      fontFamily: GoogleFonts.inter().fontFamily,
                      color: Colors.white),
                  // Agrega un hint al DropdownButton
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_downward, color: Colors.white),
                  iconSize: 24,
                  elevation: 16,
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue;
                      typeController.text = newValue ?? '';
                    });
                  },
                  validator: _userController.validateField,
                  items: <String>['client', 'barber']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ));
  }

  //Boton donde se valida los campos y la logica de negocio
  ElevatedButton RegisterButton(_key) {
    return ElevatedButton(
      onPressed: () async {
        _isLoading.value = true;

        await _userController.registerUser(
          context,
          imageUpload,
          _key,
          nameController,
          lastNameController,
          emailController,
          passwordController,
          typeController,
        );

        _isLoading.value = false;
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFD9AD26),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      child: Text(
        'Register',
        style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w400,
            letterSpacing: 0),
      ),
    );
  }
}
