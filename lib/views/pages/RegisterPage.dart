import 'dart:ffi';

import 'package:barvip_app/controllers/BaseController.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? dropdownValue;

  final dropdownController = TextEditingController();

  BaseController baseController = BaseController.empty();

  TextEditingController imageController = TextEditingController();

  TextEditingController nameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController confirpasswordController = TextEditingController();

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.all(50),
        child: SingleChildScrollView(
          // Agrega esto
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Center(
                  child: Text(
                'Create account',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              )),
              req_Image()
            ],
          ),
        ),
      ),
    );
  }

  Form req_Image() {
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
                const Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 4),
                ),
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  controller: imageController,
                  validator: baseController.validateField,
                  decoration: const InputDecoration(
                    labelText: 'Enter image URL',
                    labelStyle: TextStyle(color: Colors.white),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                buildTextField(
                    controller: nameController,
                    labelText: "Full name",
                    isPassword: false),
                buildTextField(
                    controller: emailController,
                    labelText: "Email",
                    isPassword: false),
                buildTextField(
                    controller: passwordController,
                    labelText: "Password",
                    isPassword: true),
                buildTextField(
                    controller: confirpasswordController,
                    labelText: "Confirm Password",
                    isPassword: true),
                reqType(),
                Container(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_key.currentState!.validate()) {
                          // Implement your logic here
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromRGBO(217, 173, 38,
                                1)), // Cambia a tu color preferido
                      ),
                      child: DefaultTextStyle(
                        style: TextStyle(
                            color:
                                Colors.white), // Cambia el color del texto aquí
                        child: Text('Submit'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Padding buildTextField({
    required TextEditingController controller,
    required String labelText,
    bool isPassword = false,
  }) {
    bool _obscureText = isPassword;
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0, 18, 0, 0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 4),
          ),
          StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return TextFormField(
                style: const TextStyle(color: Colors.white),
                controller: controller,
                validator: (value) => baseController.validateFieldAndPassword(value, passwordController),
                obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: labelText,
                  labelStyle: const TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
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
            },
          ),
        ],
      ),
    );
  }

  reqType() {
    return Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0, 18, 0, 10),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 4),
            ),
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
                  decoration: const InputDecoration(
                    labelText: 'Type',
                    labelStyle: const TextStyle(
                      color: Colors.white,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    
                  ),
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
                      child: Text(value, style: TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ));
  }
}
