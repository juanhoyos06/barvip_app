import 'package:cloud_firestore/cloud_firestore.dart';

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
}
