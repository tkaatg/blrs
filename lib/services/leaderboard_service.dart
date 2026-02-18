import 'dart:math';
import '../models/player_model.dart';
import 'utils/pseudo_generator.dart';

class LeaderboardEntry {
  final String uid;
  final String pseudo;
  final int points;
  final String avatarId;
  int rank;

  LeaderboardEntry({
    required this.uid,
    required this.pseudo,
    required this.points,
    required this.avatarId,
    this.rank = 0,
  });
}

class LeaderboardService {
  static List<LeaderboardEntry>? _mockLeaderboard;

  /// Generates or returns the cached mock leaderboard (for offline/demo mode)
  static List<LeaderboardEntry> getMockLeaderboard() {
    if (_mockLeaderboard != null) return _mockLeaderboard!;

    final List<LeaderboardEntry> bots = [];
    final Random random = Random();
    
    // Distribution from the table
    // niveau : (count, minScore, maxScore)
    final Map<int, List<int>> distribution = {
      10: [94, 7000, 14000],
      9: [206, 6300, 12600],
      8: [291, 5600, 11200],
      7: [309, 4900, 9800],
      6: [416, 4200, 8400],
      5: [484, 3500, 7000],
      4: [582, 2800, 5600],
      3: [623, 2100, 4200],
      2: [931, 1400, 2800],
      1: [1000, 5, 1400],
    };

    final List<String> avatars = ['circle', 'triangle', 'square', 'diamond'];

    distribution.forEach((level, config) {
      int count = config[0];
      int minS = config[1];
      int maxS = config[2];

      for (int i = 0; i < count; i++) {
        // Generate score ending in 0 or 5
        int rawScore = minS + random.nextInt(maxS - minS + 1);
        int formattedScore = (rawScore ~/ 5) * 5; 
        
        bots.add(LeaderboardEntry(
          uid: 'bot_$level\_$i',
          pseudo: PseudoGenerator.generate(),
          points: formattedScore,
          avatarId: avatars[random.nextInt(avatars.length)],
        ));
      }
    });

    // Sort by points descending
    bots.sort((a, b) => b.points.compareTo(a.points));

    // Assign Ranks (handling ties)
    int currentRank = 1;
    for (int i = 0; i < bots.length; i++) {
      if (i > 0 && bots[i].points < bots[i - 1].points) {
        currentRank = i + 1;
      }
      bots[i].rank = currentRank;
    }

    _mockLeaderboard = bots;
    return _mockLeaderboard!;
  }

  /// Inyects the real player into the leaderboard and returns the filtered view
  static List<LeaderboardEntry> getLeaderboardView(Player currentPlayer) {
    List<LeaderboardEntry> fullList = List.from(getMockLeaderboard());
    
    // Remove if player already in (e.g. if we had real Firestore data)
    fullList.removeWhere((e) => e.uid == currentPlayer.uid);
    
    // Add real player
    fullList.add(LeaderboardEntry(
      uid: currentPlayer.uid,
      pseudo: currentPlayer.pseudo,
      points: currentPlayer.points,
      avatarId: currentPlayer.avatarId,
    ));

    // Re-sort and re-rank
    fullList.sort((a, b) => b.points.compareTo(a.points));
    
    int currentRank = 1;
    int playerIdx = -1;
    for (int i = 0; i < fullList.length; i++) {
      if (i > 0 && fullList[i].points < fullList[i - 1].points) {
        currentRank = i + 1;
      }
      fullList[i].rank = currentRank;
      if (fullList[i].uid == currentPlayer.uid) {
        playerIdx = i;
      }
    }

    int playerRank = fullList[playerIdx].rank;

    // Logic: TOP 10 or (TOP 3 + WINDOW)
    if (playerRank <= 10) {
      // Show exactly Top 10
      return fullList.take(10).toList();
    } else {
      // Show Top 3
      List<LeaderboardEntry> view = fullList.take(3).toList();
      
      // Add Separator placeholder (pseudo = "...")
      view.add(LeaderboardEntry(uid: 'sep', pseudo: '...', points: -1, avatarId: ''));

      // Add window [playerIndex - 2 to playerIndex + 2]
      int start = (playerIdx - 2).clamp(0, fullList.length - 1);
      int end = (playerIdx + 2).clamp(0, fullList.length - 1);
      
      // Avoid overlapping with Top 3
      if (start < 3) start = 3;

      view.addAll(fullList.sublist(start, end + 1));
      
      return view;
    }
  }
}
