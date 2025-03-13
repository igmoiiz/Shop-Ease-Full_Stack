import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DatabaseServices extends ChangeNotifier {
  //  Instance for Firebase Firestore
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  //  Getters
  FirebaseFirestore get fireStore => _fireStore;
}
