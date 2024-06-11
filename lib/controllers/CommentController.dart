import 'package:barvip_app/models/Comment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

final FirebaseStorage storage = FirebaseStorage.instance;
FirebaseFirestore db = FirebaseFirestore.instance;

class CommentController {
  final String collection = 'Comments';

  Future<Map<String, dynamic>> saveData(Map<String, dynamic> data) async {
    try {
      await db.collection(collection).doc(data['id']).set(data);
      return {"success": true, "state": 200};
    } catch (e) {
      return {"success": false, "state": 500};
    }
  }

  Future<List<Comment>> getComments() async {
    QuerySnapshot querySnapshot = await db.collection(collection).get();
    List<DocumentSnapshot> commentsFirebase = querySnapshot.docs;
    List<Comment> comments = commentsFirebase.map((doc) {
      return Comment(
        idBarber: doc['idBarber'],
        comment: doc['comment'],
        date: doc['date'],
      );
    }).toList();

    return comments;
  }
  Future<List<Comment>> getCommentsForBarber(String barberId) async {
    QuerySnapshot querySnapshot = await db.collection(collection).where('idBarber', isEqualTo: barberId).get();
    List<DocumentSnapshot> commentsFirebase = querySnapshot.docs;
    List<Comment> commentsForBarber = commentsFirebase.map((doc) {
      return Comment(
        idBarber: doc['idBarber'],
        comment: doc['comment'],
        date: doc['date'],
      );
    }).toList();

    return commentsForBarber;
  }

  
}
