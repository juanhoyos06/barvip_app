import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
FirebaseFirestore db = FirebaseFirestore.instance;

class BaseController {
  final String collection;

  BaseController(this.collection);

  BaseController.empty({
    this.collection=""
  });

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

   String? validateFieldAndPassword(String? value, TextEditingController passwordController) {
    if (value == null || value.isEmpty) {
      return 'Este campo no puede estar vacío';
    }
    if (value.length < 6) {
      return ' La contraseña debe tener al menos 6 caracteres';
    }
    if (value != passwordController.text) {
      return 'Las contraseñas no coinciden';
    }
    
    return null;
  }

  Future<XFile?> getImage()async{

     final ImagePicker picker = ImagePicker();
     final XFile? image = await picker.pickImage(source: ImageSource.gallery);

     return image;

  }
  
  
  }
