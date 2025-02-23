import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreInstance {
  final FirebaseFirestore _instance;

  const FirestoreInstance({required FirebaseFirestore instance}) : _instance = instance;

  FirebaseFirestore get instance => _instance;
}

FirestoreInstance? firestoreInstance;

makeFirestoreInstance({required FirebaseFirestore instance}) {
  firestoreInstance = FirestoreInstance(instance: instance);
}