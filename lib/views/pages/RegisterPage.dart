import 'dart:ffi';
import 'dart:io';

import 'package:barvip_app/controllers/BaseController.dart';
import 'package:barvip_app/views/pages/LobbyPage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:barvip_app/views/pages/LoginPage.dart';
import 'package:image_picker/image_picker.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? dropdownValue;
  bool _obscureText = true;

  File? imageUpload;

  ValueNotifier<bool> passwordObscureTextNotifier = ValueNotifier(true);
  ValueNotifier<bool> confirmPasswordObscureTextNotifier = ValueNotifier(true);

  final dropdownController = TextEditingController();

  BaseController baseController = BaseController.empty();

  TextEditingController nameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController confirpasswordController = TextEditingController();

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isImageSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
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
                  labelText: "Full name",
                ),
                buildTextField(
                  controller: emailController,
                  labelText: "Email",
                ),
                buildTextFieldPassword(
                  controller: passwordController,
                  labelText: "Password",
                  obscureTextNotifier: passwordObscureTextNotifier,
                ),
                buildTextFieldPassword(
                    controller: confirpasswordController,
                    labelText: "Confirm Password",
                    obscureTextNotifier: confirmPasswordObscureTextNotifier),
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
        final imagen = await baseController.getImage();
        if (imagen != null) {
          setState(() {
            imageUpload = File(imagen.path);
            isImageSelected = true;
          });
        } else {
          setState(() {
            isImageSelected = false;
          });
        }
      },
      child: CircleAvatar(
        backgroundImage: imageUpload != null
            ? FileImage(imageUpload!)
            : const AssetImage('lib/assets/images/user_profile.png') as ImageProvider,
        radius: 60,
        backgroundColor: Colors.grey[200],
      ),
    );
  }

  Padding buildTextField({
    required TextEditingController controller,
    required String labelText,
  }) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 18, 0, 0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          paddingForms(labelText),
          TextFormField(
            controller: controller,
            validator: baseController.validateField,
            decoration: decorationFields(),
            style: TextStyle(
                fontFamily: GoogleFonts.inter().fontFamily,
                color: Colors.white),
          )
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

  Padding buildTextFieldPassword({
    required TextEditingController controller,
    required String labelText,
    required ValueNotifier<bool> obscureTextNotifier,
  }) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 18, 0, 0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          paddingForms(labelText),
          ValueListenableBuilder<bool>(
            valueListenable: obscureTextNotifier,
            builder: (context, obscureText, child) {
              return TextFormField(
                controller: controller,
                obscureText: obscureText,
                validator: (value) => baseController.validateFieldAndPassword(
                    value, passwordController),
                decoration:
                    DecorationsPassword(obscureText, obscureTextNotifier),
                style: TextStyle(
                    fontFamily: GoogleFonts.inter().fontFamily,
                    color: Colors.white),
              );
            },
          ),
        ],
      ),
    );
  }

  InputDecoration DecorationsPassword(
      bool obscureText, ValueNotifier<bool> obscureTextNotifier) {
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
      suffixIcon: IconButton(
        icon: Icon(
          obscureText ? Icons.visibility : Icons.visibility_off,
        ),
        onPressed: () {
          obscureTextNotifier.value = !obscureText;
        },
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
                      dropdownController.text = newValue ?? '';
                    });
                  },
                  validator: baseController.validateField,
                  items: <String>['Client', 'Barber']
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

  ElevatedButton RegisterButton(_key) {
    return ElevatedButton(
      onPressed: () {
        if (_key.currentState!.validate()) {
          // Implement your logic here
        }
        if (imageUpload == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                'Please select an image',
                style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0),
              ),
              duration: Duration(seconds: 2),
            ),
          );
        }
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
