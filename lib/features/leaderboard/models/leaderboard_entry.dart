import 'package:cloud_firestore/cloud_firestore.dart';

enum RankChange { up, down, neutral }

class LeaderboardEntry {
  final String id;
  final String name;
  final int score;
  final int rank;
  final String? avatarUrl;
  final RankChange rankChange;
  final DateTime? createdAt;
  final String? email;

  LeaderboardEntry({
    required this.id,
    required this.name,
    required this.score,
    required this.rank,
    this.avatarUrl,
    this.rankChange = RankChange.neutral,
    this.createdAt,
    this.email,
  });

  factory LeaderboardEntry.fromFirestore(DocumentSnapshot doc, int rank) {
    final data = doc.data() as Map<String, dynamic>;
    return LeaderboardEntry(
      id: doc.id,
      name: data['username'] ?? 'Anonymous',
      score: data['score'] ?? (data['highestScore'] ?? 0),
      rank: rank,
      email: data['email'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      rankChange:
          RankChange.neutral, // Firestore data doesn't provide rank change yet
    );
  }
}
