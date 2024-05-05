import 'package:barvip_app/controllers/BaseController.dart';
import 'package:barvip_app/models/Client.dart';
import 'package:barvip_app/views/pages/DashBoardBarberPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

const String collection = 'client';

class ClientController extends BaseController {
  ClientController() : super(collection);

  Future<Map<String, dynamic>> saveClient(Client client) async {
    return await saveData(client.toJson());
  }

  Future<void> updateClient(Client client, String id) async {
    await updateData(client.toJson(), id);
  }
}
