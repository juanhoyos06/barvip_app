import 'package:barvip_app/models/Barber.dart';
import 'package:barvip_app/views/pages/DashBoardBarberPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:barvip_app/models/Client.dart';
import 'package:image_picker/image_picker.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

class BaseController {
  final String collection;

  BaseController([this.collection = '']);

  BaseController.empty({this.collection = ""});

  saveData(Map<String, dynamic> data) async {
    try {
      return db.collection(collection).add(data).toString();
    } catch (e) {
      return null;
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
      return  'Please enter a valid email';
    }
    

  }

   String? validateFieldAndPassword(String? value, TextEditingController passwordController) {
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
        confirmPassword: doc['confirmPassword'],
        typeUser: doc['typeUser'],
      );
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
        confirmPassword: doc['confirmPassword'],
        typeUser: doc['typeUser'],
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
    Future<XFile?> getImage()async{

     final ImagePicker picker = ImagePicker();
     final XFile? image = await picker.pickImage(source: ImageSource.gallery);

     return image;

  }
}
