import 'dart:io';

import 'package:barvip_app/controllers/BarberController.dart';
import 'package:barvip_app/controllers/ClientController.dart';
import 'package:barvip_app/models/Barber.dart';
import 'package:barvip_app/views/pages/DashBoardBarberPage.dart';
import 'package:barvip_app/views/pages/LoginPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:barvip_app/models/Client.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

final FirebaseStorage storage = FirebaseStorage.instance;
FirebaseFirestore db = FirebaseFirestore.instance;

class BaseController {
  final String collection;

  BaseController([this.collection = '']);

  BaseController.empty({this.collection = ""});

  Future<Map<String, dynamic>> saveData(Map<String, dynamic> data) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(collection)
          .where('email', isEqualTo: data['email'])
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        print('El documento ya existe en la base de datos');
        return {'success': false, 'state': 409};
      } else {
        DocumentReference docRef =
            await FirebaseFirestore.instance.collection(collection).add(data);
        await docRef.update({'id': docRef.id});
        return {'success': true, 'state': 200};
      }
    } catch (e) {
      return {'success': false, 'state': 500};
    }
  }

  updateData(Map<String, dynamic> data, String id) async {
    await db.collection(collection).doc(id).update(data);
  }

  String? validateField(value) {
    return value == null || value.isEmpty ? "Este campo es obligatorio" : null;
  }

  String? validateName(value) {
    validateField(value);
    if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
      return "Este campo solo debe contener letras";
    }
  }

  String? validateEmail(value) {
    validateField(value);
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Please enter a valid email';
    }
  }

  String? validateFieldAndPassword(
      String? value, TextEditingController passwordController) {
    validateField(value);

    if (value!.length < 6) {
      return ' La contraseña debe tener al menos 6 caracteres';
    }
    if (value != passwordController.text) {
      return 'Las contraseñas no coinciden';
    }

    return null;
  }

  Future<bool> loginFirebase(
      String email, String password, BuildContext context) async {
    //Bandera para saber si el usuario fue encontrado
    bool userFound = false;

    // Primera consulta a la collecion de clientes

    QuerySnapshot querySnapshot1 =
        await FirebaseFirestore.instance.collection('testLogin').get();
    List<DocumentSnapshot> docs1 = querySnapshot1.docs;

    List<Client?> users1 = docs1.map((doc) {
      return Client(
          name: doc['name'],
          lastName: doc['lastName'],
          email: doc['email'],
          password: doc['password'],
          typeUser: doc['typeUser'],
          urlImage: doc['urlImage']);
    }).toList();

    // Segunda consulta a la collecion de barberos
    QuerySnapshot querySnapshot2 =
        await FirebaseFirestore.instance.collection('testLoginBarber').get();
    List<DocumentSnapshot> docs2 = querySnapshot2.docs;

    List<Barber?> users2 = docs2.map((doc) {
      return Barber(
        name: doc['name'],
        lastName: doc['lastName'],
        email: doc['email'],
        password: doc['password'],
        typeUser: doc['typeUser'],
        urlImage: doc['urlImage'],
      );
    }).toList();

    print('Este es el primer Cliente de la lista ${users1[0]?.name}');
    print('Este es el primer Barbero de la segunda lista ${users2[0]?.name}');

    if (users1.isNotEmpty || users2.isNotEmpty) {
      // Aqui se busca Si el usuario esta en cliente.
      for (var user in users1) {
        if (user?.email == email &&
            user?.password == password &&
            user?.typeUser == 'client') {
          print('Usuario encontrado cliente');
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DashBoardBarberPage(),
          ));
          // si se encuentra el usuario
          userFound = true;
        }
      }
      // Aqui se busca si el usuario es barbero
      for (var user in users2) {
        if (user?.email == email &&
            user?.password == password &&
            user?.typeUser == 'barber') {
          print('Usuario barbero encontrado');
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DashBoardBarberPage(),
          ));
          userFound = true;
        }
      }
    }
    return userFound;
  }

  void validateFieldLogin(
      String? email, String? password, BuildContext context) async {
    // Bandera para saber si el usuario fue encontrado
    bool userFound = false;
    // Este es el mensaje de validación que se mostrará en el SnackBar
    String? validationMessage;
    if (email == null || email.isEmpty) {
      validationMessage = 'Email is required';
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      validationMessage = 'Please enter a valid email';
    } else if (password == null || password.isEmpty) {
      validationMessage = 'Password is required';
    }
    // Si hay un mensaje de validación, se muestra en un SnackBar
    if (validationMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          validationMessage,
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ));
    } else {
      // LoginFireBase retorna true si el usuario fue encontrado.
      userFound = await loginFirebase(email!, password!, context);
    }
    // Si el usuario no fue encontrado, se muestra un SnackBar
    if (!userFound) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Credenciales incorrectas',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w700),
          )));
    }
  }

  Future<XFile?> getImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    return image;
  }

  Future<dynamic> uploadImage(File image) async {
    final String nameFile = image.path.split("/").last;
    Reference ref = storage.ref().child("images_profile").child(nameFile);
    final UploadTask uploadTask = ref.putFile(image);

    final TaskSnapshot snapshot = await uploadTask.whenComplete(() => true);

    final String url = await snapshot.ref.getDownloadURL();

    if (snapshot.state == TaskState.success) {
      return url;
    } else {
      return false;
    }
  }

  void logicButton(
    context,
    BaseController baseController,
    ClientController clientController,
    BarberController barberController,
    imageUpload,
    GlobalKey<FormState> _key,
    TextEditingController nameController,
    TextEditingController lastNameController,
    TextEditingController emailController,
    TextEditingController passwordController,
    TextEditingController typeController,
  ) async {
    if (_key.currentState!.validate() && imageUpload != null) {
      if (typeController.text == "Client") {
        // Llamar al metodo de subir imagen que nos devuelve la url si se subio correctamente
        final dynamic urlClient =
            await baseController.uploadImage(imageUpload!);
        Client newClient = Client(
          name: nameController.text,
          lastName: lastNameController.text,
          email: emailController.text,
          password: passwordController.text,
          typeUser: typeController.text,
          urlImage: urlClient,
        );
        final Map<String, dynamic> response =
            await clientController.saveClient(newClient);
        logicUsers(response, context);
      } else {
        // Llamar al metodo de subir imagen que nos devuelve la url si se subio correctamente
        final dynamic urlBarber =
            await baseController.uploadImage(imageUpload!);
        Barber newBarber = Barber(
          name: nameController.text,
          lastName: lastNameController.text,
          email: emailController.text,
          password: passwordController.text,
          typeUser: typeController.text,
          urlImage: urlBarber,
        );
        final Map<String, dynamic> response =
            await barberController.saveBarber(newBarber);
        logicUsers(response, context);
      }
    }
    if (imageUpload == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        snackbarRegister("Plese select an image", Colors.red),
      );
    }
  }

  SnackBar snackbarRegister(labelText, Color backgroundColor) {
    return SnackBar(
      backgroundColor: backgroundColor,
      content: Text(
        labelText,
        style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w400,
            letterSpacing: 0),
      ),
      duration: Duration(seconds: 2),
    );
  }

  void logicUsers(response, context) {
    if (response['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        snackbarRegister("Congratulations, your user was created successfully ",
            Colors.green),
      );
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => LoginPage(),
      ));
    }
    if (response['state'] == 409) {
      ScaffoldMessenger.of(context).showSnackBar(
        snackbarRegister("The email already exists", Colors.red),
      );
    }
    if (response['success'] == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        snackbarRegister("Error creating your user", Colors.red),
      );
    }
  }
}
