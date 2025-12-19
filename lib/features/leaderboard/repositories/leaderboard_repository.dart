import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/leaderboard_entry.dart';
import '../services/database_service.dart';

abstract class ILeaderboardRepository {
  Stream<List<LeaderboardEntry>> getLeaderboardStream();
}

class LeaderboardRepository implements ILeaderboardRepository {
  final DatabaseService _databaseService;

  LeaderboardRepository({required DatabaseService databaseService})
    : _databaseService = databaseService;

  @override
  Stream<List<LeaderboardEntry>> getLeaderboardStream() {
    return _databaseService
        .getLeaderboardStream()
        .handleError((error) async* {
          // Fallback to mock data on error
          final mockData = await _loadMockData();
          yield mockData;
        })
        .map((snapshot) {
          final entries = <LeaderboardEntry>[];
          for (int i = 0; i < snapshot.docs.length; i++) {
            entries.add(
              LeaderboardEntry.fromFirestore(snapshot.docs[i], i + 1),
            );
          }
          return entries;
        });
  }

  Future<List<LeaderboardEntry>> _loadMockData() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/leaderboard_mock_data.json',
      );
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.asMap().entries.map((entry) {
        final int index = entry.key;
        final Map<String, dynamic> data = entry.value;
        return LeaderboardEntry(
          id: data['id'],
          name: data['username'],
          score: data['highestScore'],
          rank: index + 1,
          email: data['email'],
          createdAt: DateTime.parse(data['createdAt']),
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }
}
