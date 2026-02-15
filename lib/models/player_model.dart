import 'package:cloud_firestore/cloud_firestore.dart';

class Player {
  final String uid;
  final String pseudo;
  final int stars;
  final int points;
  final int maxLevelUnlocked;
  final Map<String, int> statsLevels;
  final List<int> unlockedLevels;
  final DateTime createdAt;

  Player({
    required this.uid,
    required this.pseudo,
    required this.stars,
    required this.points,
    this.maxLevelUnlocked = 1,
    this.statsLevels = const {},
    this.unlockedLevels = const [1], // Level 1 is always unlocked
    required this.createdAt,
  });

  factory Player.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Player(
      uid: doc.id,
      pseudo: data['pseudo'] ?? '',
      stars: data['stars'] ?? 0,
      points: data['points'] ?? 0,
      maxLevelUnlocked: data['maxLevelUnlocked'] ?? 1,
      statsLevels: Map<String, int>.from(data['stats_levels'] ?? {}),
      unlockedLevels: List<int>.from(data['unlocked_levels'] ?? [1]),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'pseudo': pseudo,
      'stars': stars,
      'points': points,
      'maxLevelUnlocked': maxLevelUnlocked,
      'stats_levels': statsLevels,
      'unlocked_levels': unlockedLevels,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
