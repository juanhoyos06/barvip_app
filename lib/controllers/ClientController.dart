import 'package:barvip_app/controllers/BaseController.dart';
import 'package:barvip_app/models/Client.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

const String collection = 'client';

class ClientController extends BaseController {
  ClientController() : super(collection);

  Future<String> saveClient(Client client) async {
    return await saveData(client.toMap());
  }

  Future<void> updateClient(Client client, String id) async {
    await updateData(client.toMap(), id);
  }
}


