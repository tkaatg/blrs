import 'package:cloud_firestore/cloud_firestore.dart';

class Player {
  final String uid;
  String pseudo;
  int stars;
  int points; // Total points for leaderboard (sum of best scores)
  int maxLevelUnlocked;
  Map<String, int> statsLevels; // Stores best correct answers count (0-10) for UI
  Map<String, int> bestPointsByLevel; // Stores best speed score per level
  List<int> unlockedLevels;
  final DateTime createdAt;

  // Settings & Customization
  String avatarId; // circle, triangle, square, diamond
  bool musicEnabled;
  bool sfxEnabled;
  bool vibrationsEnabled;
  String languageCode; // 'fr', 'en'

  Player({
    required this.uid,
    required this.pseudo,
    required this.stars,
    required this.points,
    this.maxLevelUnlocked = 1,
    Map<String, int>? statsLevels,
    Map<String, int>? bestPointsByLevel,
    List<int>? unlockedLevels,
    required this.createdAt,
    this.avatarId = 'circle',
    this.musicEnabled = true,
    this.sfxEnabled = true,
    this.vibrationsEnabled = true,
    this.languageCode = 'fr',
  }) : this.statsLevels = statsLevels ?? {},
       this.bestPointsByLevel = bestPointsByLevel ?? {},
       this.unlockedLevels = unlockedLevels ?? [1];

  factory Player.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Player(
      uid: doc.id,
      pseudo: data['pseudo'] ?? '',
      stars: data['stars'] ?? 0,
      points: data['points'] ?? 0,
      maxLevelUnlocked: data['maxLevelUnlocked'] ?? 1,
      statsLevels: Map<String, int>.from(data['stats_levels'] ?? {}),
      bestPointsByLevel: Map<String, int>.from(data['bestPointsByLevel'] ?? {}),
      unlockedLevels: List<int>.from(data['unlocked_levels'] ?? [1]),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      avatarId: data['avatarId'] ?? 'circle',
      musicEnabled: data['musicEnabled'] ?? true,
      sfxEnabled: data['sfxEnabled'] ?? true,
      vibrationsEnabled: data['vibrationsEnabled'] ?? true,
      languageCode: data['languageCode'] ?? 'fr',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'pseudo': pseudo,
      'stars': stars,
      'points': points,
      'maxLevelUnlocked': maxLevelUnlocked,
      'stats_levels': statsLevels,
      'bestPointsByLevel': bestPointsByLevel,
      'unlocked_levels': unlockedLevels,
      'createdAt': Timestamp.fromDate(createdAt),
      'avatarId': avatarId,
      'musicEnabled': musicEnabled,
      'sfxEnabled': sfxEnabled,
      'vibrationsEnabled': vibrationsEnabled,
      'languageCode': languageCode,
    };
  }

  /// Recalculates total points as sum of all best speed scores
  void updatePointsFromBestScores() {
    points = bestPointsByLevel.values.fold(0, (sum, p) => sum + p);
  }
}
