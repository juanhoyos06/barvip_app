import 'package:barvip_app/models/qualify.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

final FirebaseStorage storage = FirebaseStorage.instance;
FirebaseFirestore db = FirebaseFirestore.instance;

class QualifyController {
  final String collection = 'qualifies';

  Future<Map<String, dynamic>> saveData(Map<String, dynamic> data) async {
    try {
      QuerySnapshot querySnapshot = await db
          .collection(collection)
          .where('idBarber', isEqualTo: data['idBarber'])
          .where('idClient', isEqualTo: data['idClient'])
          .get();
      List<DocumentSnapshot> qualifyFirebase = querySnapshot.docs;

      if (qualifyFirebase.isEmpty) {
        await db.collection(collection).add(data);
        return {"success": true, "state": 200};
      } else {
        DocumentSnapshot doc = qualifyFirebase.first;
        await db
            .collection(collection)
            .doc(doc.id)
            .update({'qualify': data['qualify'], 'date': data['date']});
        return {"success": true, "state": 200};
      }
    } catch (e) {
      return {"success": false, "state": 500};
    }
  }

  Future<List<Qualify>> getQualifys() async {
    QuerySnapshot querySnapshot = await db.collection(collection).get();
    List<DocumentSnapshot> qualifysFirebase = querySnapshot.docs;
    List<Qualify> qualifies = qualifysFirebase.map((doc) {
      return Qualify(
        idClient: doc['idClient'],
        idBarber: doc['idBarber'],
        qualify: doc['qualify'],
        date: doc['date'],
      );
    }).toList();

    return qualifies;
  }

  Future<double> getAverageQualify(String idBarber) async {
    QuerySnapshot querySnapshot1 = await db
        .collection(collection)
        .where('idBarber', isEqualTo: idBarber)
        .get();
    List<DocumentSnapshot> qualifysFirebase = querySnapshot1.docs;
    List<int?> qualifies = [];
    int totalQualify = 0;

    qualifysFirebase.forEach((doc) {
      int qualify = int.parse(doc['qualify']);
      qualifies.add(qualify);
      totalQualify += qualify;
    });

    if (qualifies.isEmpty) {
      return 0.0; // Retorna 0.0 si no hay calificaciones
    }
    

    double averageQualify = totalQualify / qualifies.length;
    
    return averageQualify;
  }

  Future<int> getSpecificQualify(String idBarber, String idClient) async {
    QuerySnapshot querySnapshot = await db
        .collection(collection)
        .where('idBarber', isEqualTo: idBarber)
        .where('idClient', isEqualTo: idClient)
        .get();
    List<DocumentSnapshot> qualifyFirebase = querySnapshot.docs;
    if (qualifyFirebase.isEmpty) {
      return 6;
    } else {
      int qualify = qualifyFirebase.first['qualify'] is String
          ? int.parse(qualifyFirebase.first['qualify'])
          : qualifyFirebase.first['qualify'] as int;
      return qualify;
    }
  }

  Future<bool> isQualified(String idBarber, String idClient) async {
    QuerySnapshot querySnapshot = await db
        .collection(collection)
        .where('idBarber', isEqualTo: idBarber)
        .where('idClient', isEqualTo: idClient)
        .get();
    List<DocumentSnapshot> qualifyFirebase = querySnapshot.docs;

    if (qualifyFirebase.isEmpty) {
      return false;
    } else {
      return true;
    }
  }
}
