// Tests expected algorithm results to actual algorithm results.
// Run with `flutter test` command.

import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  test('Test Firestore query logic', () async {
    final instance = MockFirestoreInstance();

    // Add mock data
    await instance.collection('users').add({
      'name': 'Alice',
      'age': 30,
    });

    await instance.collection('users').add({
      'name': 'Bob',
      'age': 25,
    });

    // Run Firestore query
    final querySnapshot = await instance
        .collection('users')
        .where('age', isGreaterThan: 26)
        .get();

    final results = querySnapshot.docs.map((doc) => doc['name']).toList();

    // Verify results
    expect(results, ['Alice']);
  });
}
