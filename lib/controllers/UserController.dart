import 'dart:io';

import 'package:barvip_app/controllers/UserProvider.dart';
import 'package:barvip_app/models/User.dart';
import 'package:barvip_app/utils/MyStyles.dart';
import 'package:barvip_app/views/pages/DashBoardBarberPage.dart';
import 'package:barvip_app/views/pages/LoginPage.dart';
import 'package:barvip_app/views/pages/ProfilePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

final FirebaseStorage storage = FirebaseStorage.instance;
FirebaseFirestore db = FirebaseFirestore.instance;

class UserController {
  final String collection = 'user';
  MyStyles myStyles = MyStyles();

  Future<Map<String, dynamic>> saveData(Map<String, dynamic> data) async {
    try {
      final Map<String, dynamic> existingUser =
          await getUserByEmail(data['email']);
      if (existingUser['success'] == true) {
        return {'success': false, 'state': 409};
      } else {
        print("Este es el data ${data}");
        // Se guarda el user con el id que esta dentro de los datos
        await FirebaseFirestore.instance
            .collection(collection)
            .doc(data['id'])
            .set(data);
        /* await docRef.update({'id': docRef.id}); */
        return {'success': true, 'state': 200};
      }
    } catch (e) {
      return {'success': false, 'state': 500};
    }
  }

  Future<Map<String, dynamic>> getUserByEmail(String email) async {
    QuerySnapshot querySnapshot =
        await db.collection(collection).where('email', isEqualTo: email).get();
    if (querySnapshot.docs.isNotEmpty) {
      return {'success': true, 'data': querySnapshot.docs.first.data()};
    } else {
      return {'success': false, 'data': null};
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

    if (value!.length < 8) {
      return ' La contraseña debe tener al menos 8 caracteres';
    }
    if (value != passwordController.text) {
      return 'Las contraseñas no coinciden';
    }

    return null;
  }

  Future<List<bool>> loginFirebase(String email, String password,
      BuildContext context, UserProvider userProvider, isLoading) async {
    try {
      // Inicia sesión con Firebase Auth
      auth.UserCredential userCredential =
          await auth.FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      auth.User? firebaseUser = userCredential.user;
      print("El usuario de firebase user es ${firebaseUser}");

      if (firebaseUser != null) {
        // Consulta a la colección de usuarios
        print("Este es el id de calicheeeeee${firebaseUser.uid}");

        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection(collection)
            .where('id', isEqualTo: firebaseUser.uid)
            .get();

        List<DocumentSnapshot> docs = querySnapshot.docs;

        if (docs.isNotEmpty) {
          DocumentSnapshot userDoc = docs.first;
          print("USERDOCCCCCCCCCCCCCC ${userDoc.exists}");

          if (userDoc.exists) {
            print("Entre al condicional el usuario existe ${userDoc}");
            User user = User(
                id: userDoc['id'],
                name: userDoc['name'],
                lastName: userDoc['lastName'],
                email: userDoc['email'],
                password: userDoc['password'],
                typeUser: userDoc['typeUser'],
                urlImage: userDoc['urlImage']);

            userProvider.userFromDb(user);

            if (user.typeUser == 'client') {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => DashBoardBarberPage(),
              ));
            } else {
              isLoading.value = false;
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => DashBoardBarberPage(),
              ));
            }
            print("Voy a retornar true");
            isLoading.value = false;
            return [true, isLoading.value];
          }
        }
      }
    } on auth.FirebaseAuthException catch (e) {
      print(e.message);
    }
    print("Voy a retornar false");
    isLoading.value = false;
    return [false, isLoading.value];
  }

  Future<List<dynamic>> validateFieldLogin(String? email, String? password,
      BuildContext context, UserProvider userProvider, isLoading) async {
    // Bandera para saber si el usuario fue encontrado

    List<dynamic> result = [];

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
      result = await loginFirebase(
          email!, password!, context, userProvider, isLoading);
    }
    // Si el usuario no fue encontrado, se muestra un SnackBar
    if (!result[0]) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Credenciales incorrectas',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w700),
          )));
    }
    // en el index 1 se encuentra el valor de isLoading para detener la animacion
    return result;
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

/*   void registerUser(
    context,
    imageUpload,
    GlobalKey<FormState> _key,
    TextEditingController nameController,
    TextEditingController lastNameController,
    TextEditingController emailController,
    TextEditingController passwordController,
    TextEditingController typeController,
  ) async {
    if (_key.currentState!.validate() && imageUpload != null) {
      final dynamic urlClient = await uploadImage(imageUpload!);
      User newUser = User(
        name: nameController.text,
        lastName: lastNameController.text,
        email: emailController.text,
        password: passwordController.text,
        typeUser: typeController.text,
        urlImage: urlClient,
      );

      final Map<String, dynamic> response = await saveData(
          newUser.toJson()); //Esta funcion responde un Map con succes y state
      logicUsers(response, context);
    }
    if (imageUpload == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        myStyles.snackbar("Plese select an image", Colors.red),
      );
    }
  }
 */
/* void registerUser(
    context,
    imageUpload,
    GlobalKey<FormState> _key,
    TextEditingController nameController,
    TextEditingController lastNameController,
    TextEditingController emailController,
    TextEditingController passwordController,
    TextEditingController typeController,
  ) async {
    if (_key.currentState!.validate() && imageUpload != null) {
      final dynamic urlClient = await uploadImage(imageUpload!);
        String name =nameController.text;
        String lastName=lastNameController.text;
        String email= emailController.text;
        String password= passwordController.text;
        String typeUser= typeController.text;
        String urlImage= urlClient;
   

      final Map<String, dynamic> response = await _authController.registerWithEmailPassword(
          email, password, name, lastName, typeUser, urlImage); //Esta funcion responde un Map con succes y state
      logicUsers(response, context);
    }
    if (imageUpload == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        myStyles.snackbar("Plese select an image", Colors.red),
      );
    }
  } */

  Future<void> registerUser(
    context,
    imageUpload,
    GlobalKey<FormState> _key,
    TextEditingController nameController,
    TextEditingController lastNameController,
    TextEditingController emailController,
    TextEditingController passwordController,
    TextEditingController typeController,
  ) async {
    if (_key.currentState!.validate() && imageUpload != null) {
      final dynamic urlClient = await uploadImage(imageUpload!);

      try {
        auth.UserCredential userCredential = await auth.FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);

        // Una vez que el usuario se ha registrado correctamente, podemos añadir sus datos a Firestore
        print(
            "id firebase--------------------------------------${userCredential.user!.uid}"); // Imprimimos el UID del usuario (opcional
        User newUser = User(
          id: userCredential.user!.uid, // Aquí guardamos el UID del usuario
          name: nameController.text,
          lastName: lastNameController.text,
          email: emailController.text,
          password: passwordController.text,
          typeUser: typeController.text,
          urlImage: urlClient,
        );

        final Map<String, dynamic> response = await saveData(newUser.toJson());

        logicUsers(response, context);
      } on auth.FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        }
      } catch (e) {
        print(e);
      }
    }
    if (imageUpload == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        myStyles.snackbar("Please select an image", Colors.red),
      );
    }
  }

  void logicUsers(response, context) {
    if (response['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        myStyles.snackbar(
            "Congratulations, your user was created successfully ",
            Colors.green),
      );
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => LoginPage(),
      ));
    }
    if (response['state'] == 409) {
      ScaffoldMessenger.of(context).showSnackBar(
        myStyles.snackbar("The email already exists", Colors.red),
      );
    }
    if (response['success'] == false) {
      ScaffoldMessenger.of(context).showSnackBar(
        myStyles.snackbar("Error creating your user", Colors.red),
      );
    }
  }

  Stream<QuerySnapshot> usersStream() {
    return db
        .collection(collection)
        .where('typeUser', isEqualTo: 'barber')
        .snapshots();
  }

  void EditUser(
    UserProvider userProvider,
    context,
    userController,
    imageUpload,
    _key,
    TextEditingController nameController,
    TextEditingController lastNameController,
    TextEditingController emailController,
    TextEditingController passwordController,
    TextEditingController typeController,
  ) async {
    dynamic urlImageProfile;

    if (_key.currentState!.validate() && imageUpload != null) {
      print("el formulario es valido e imageUpload tienen algo ${imageUpload}");
      // Si el path de la foto de usuario contiene googleusercontent entonces esta no exite en nuestra base de datos por lo tanto debemos crearla.
      if (userProvider.users['urlImage'].contains('googleusercontent')) {
        print("entre al cambio de imagen de google");
        urlImageProfile = await uploadImage(imageUpload!);
      } else {
        urlImageProfile =
            await updateImage(userProvider.users['urlImage'], imageUpload);
      }

      print(
          'Este es el nombre actualizado de NameController.text ${nameController.text}');

      print("user BEfore update ${userProvider.users}");

      User userUpdated = User(
        id: userProvider.users['id'],
        name: nameController.text,
        lastName: lastNameController.text,
        email: emailController.text,
        password: passwordController.text,
        typeUser: typeController.text,
        urlImage: urlImageProfile!,
      );

      print("User updated ${userUpdated.urlImage}");

      // Actualizar la información del usuario
      updateData(userUpdated.toJson(), userProvider.users['id']);
      // Actualziar la información del usuario en el provider
      userProvider.userFromDb(userUpdated);
      // Enviamos al usuario a la pagina de perfil.
      Navigator.of(context).pop(MaterialPageRoute(
        builder: (context) => ProfilePage(),
      ));
    }
    if (imageUpload == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        myStyles.snackbar("Plese select an image", Colors.red),
      );
    }
  }

  dynamic updateImage(String? url, File image) async {
    // url es de la imagen que ya exite en la base de datos
    // una vez se tiene esa referencia se actualiza el path con la nueva imagen.
    Reference ref = storage.refFromURL(url!);
    // putFile guarda la nueva imagen en el path de la imagen anterior
    final UploadTask uploadTask = ref.putFile(image);
    // indica cuando se completa la subida de la imagen
    final TaskSnapshot snapshot = await uploadTask.whenComplete(() => true);
    // retornamos la uri que debemos actualizar en la base de datos del usuario
    final String uri = await snapshot.ref.getDownloadURL();

    if (snapshot.state == TaskState.success) {
      return uri;
    } else {
      return false;
    }
  }

  Future<void> deleteUser(UserProvider userProvider, context) async {
    // Si la imagen del usuario no contiene googleusercontent, si exite en el storage y debemos eliminarla
    if (!userProvider.users['urlImage'].contains('googleusercontent')) {
      // Obtén la URL de la imagen del usuario
      String imageUrl = userProvider.users['urlImage'];

      // Crea una referencia a la imagen
      Reference ref = FirebaseStorage.instance.refFromURL(imageUrl);

      // Elimina la imagen
      await ref.delete().catchError((error) {
        print("Error al eliminar la imagen: $error");
      });
    }

    print(
        "Este es el id del usuario que voy a eliminar ${userProvider.users['id']}");
    // Elimina el usuario de la base de datos
    await db.collection(collection).doc(userProvider.users['id']).delete();
    // Elimina el usuario de Firebase Auth
    print(
        "Este es el usuario actual ${auth.FirebaseAuth.instance.currentUser}");
    await auth.FirebaseAuth.instance.currentUser!.delete();

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => LoginPage(),
    ));

    ScaffoldMessenger.of(context).showSnackBar(
      myStyles.snackbar("Account deleted correctly.", Colors.red),
    );
  }
}
