import 'dart:io';

import 'package:barvip_app/controllers/UserController.dart';
import 'package:barvip_app/controllers/UserProvider.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  //Variables declaration
  String? dropdownValue;
  File? imageUpload;

  //Controller declaration
  final typeController = TextEditingController();
  UserController userController = UserController();
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirpasswordController = TextEditingController();

  //keys declarations
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late UserProvider userProvider;

  @override
  void initState() {
    super.initState();

    userProvider = Provider.of<UserProvider>(context, listen: false);
    dropdownValue = userProvider.users['typeUser'];
    typeController.text = userProvider.users['typeUser'];
    nameController.text = userProvider.users['name'];
    lastNameController.text = userProvider.users['lastName'];
    emailController.text = userProvider.users['email'];
    passwordController.text = userProvider.users['password'];
    confirpasswordController.text = userProvider.users['password'];
  }

  @override
  Widget build(BuildContext context) {
    print({'user': userProvider.users});
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
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.keyboard_arrow_left,
                        color: Colors.white,
                      ))),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 24, 0, 0),
                child: Text(
                  'Update account',
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
                    labelText: "Name",
                    isPassword: false,
                    validatorField: userController.validateName,
                    isEnable: true),
                buildTextField(
                    controller: lastNameController,
                    labelText: "Last Name",
                    isPassword: false,
                    validatorField: userController.validateName,
                    isEnable: true),
                buildTextField(
                    controller: emailController,
                    labelText: "Email",
                    isPassword: false,
                    validatorField: userController.validateEmail,
                    isEnable: false),
                buildTextField(
                    controller: passwordController,
                    labelText: "Password",
                    isPassword: true,
                    validatorField: (value) =>
                        userController.validateFieldAndPassword(
                            value, confirpasswordController),
                    isEnable: true),
                buildTextField(
                    controller: confirpasswordController,
                    labelText: "Confirm Password",
                    isPassword: true,
                    validatorField: (value) => userController
                        .validateFieldAndPassword(value, passwordController),
                    isEnable: true),
                textFieldType(),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                      height: 50,
                      width: double.infinity,
                      child: updateButton(_key)),
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
        final imagen = await userController.getImage();
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
            : NetworkImage(userProvider.users['urlImage']) as ImageProvider,
        radius: 60,
        backgroundColor: Colors.grey[200],
      ),
    );
  }

  Padding buildTextField(
      {required TextEditingController controller,
      required String labelText,
      bool isPassword = false,
      required validatorField,
      required isEnable}) {
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
              enabled: isEnable,
              style:
                  TextStyle(color: isEnable ? Colors.white : Colors.grey[600]),
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
                  icon: Icon(Icons.arrow_downward, color: Colors.grey[600]),
                  iconSize: 24,
                  elevation: 16,
                  onChanged: null,
                  validator: userController.validateField,
                  items: <String>['client', 'barber']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: GoogleFonts.inter(
                            color: Colors.grey[600],
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
  ElevatedButton updateButton(_key) {
    return ElevatedButton(
      // imageUpload es el File con el pth de la imagen nueva que se va guardar
      onPressed: () {
        print('path image$imageUpload');
        print("");
        /* 'userProvider: ${userProvider.users}, nameController: $nameController, lastNameController: $lastNameController, emailController: $emailController, passwordController: $passwordController, typeController: $typeController');
        userController.EditUser(
          userProvider,
          context,
          userController,
          imageUpload,
          _key,
          nameController,
          lastNameController,
          emailController,
          passwordController,
          typeController,
        ); */
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFD9AD26),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      child: Text(
        'Update',
        style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w400,
            letterSpacing: 0),
      ),
    );
  }
}
