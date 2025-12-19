import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveUserProfile({
    required String uid,
    required String email,
    required String username,
  }) async {
    await _firestore.collection('users').doc(uid).set({
      'uid': uid,
      'email': email,
      'username': username,
      'createdAt': FieldValue.serverTimestamp(),
      'highestScore': 0,
    });
  }

  Future<void> updateHighScore(String uid, int score) async {
    final userDoc = _firestore.collection('users').doc(uid);
    final doc = await userDoc.get();

    if (doc.exists) {
      final currentHigh = doc.data()?['highestScore'] ?? 0;
      if (score > currentHigh) {
        await userDoc.update({'highestScore': score});

        // Update leaderboard
        await _firestore.collection('leaderboard').doc(uid).set({
          'uid': uid,
          'username': doc.data()?['username'] ?? 'Anonymous',
          'score': score,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    }
  }

  Stream<QuerySnapshot> getLeaderboardStream() {
    return _firestore
        .collection('users')
        .orderBy('highestScore', descending: true)
        .limit(50)
        .snapshots();
  }

  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.data();
  }
}
