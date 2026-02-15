enum LevelState { locked, available, completed }

class LevelStatus {
  final int id;
  final LevelState state;
  final int score; // 0 to 5
  final bool isCurrent;

  LevelStatus({
    required this.id,
    required this.state,
    this.score = 0,
    this.isCurrent = false,
  });

  // Helper to determine background color based on score
  int get starsCount {
    if (score >= 5) return 3;
    if (score >= 3) return 2;
    if (score >= 1) return 1;
    return 0;
  }
}
