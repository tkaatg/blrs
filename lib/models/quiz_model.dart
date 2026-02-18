enum Difficulty { easy, medium, hard }
enum SignCategory { danger, restriction, obligation, indication, info }

class Question {
  final String id;
  final String text;
  final String signContentImage; // e.g. 'assets/images/signs/content_danger_pedestrian.png'
  final String fullSignImage;    // e.g. 'assets/images/signs/full_danger_pedestrian.png'
  final String correctShapeId;   // 'triangle', 'circle', 'square'
  final List<String> distractorShapeIds;
  final Difficulty difficulty;
  final SignCategory category;
  final String hintLabel;

  const Question({
    required this.id,
    required this.text,
    required this.signContentImage,
    required this.fullSignImage,
    required this.correctShapeId,
    required this.distractorShapeIds,
    this.difficulty = Difficulty.easy,
    required this.category,
    required this.hintLabel,
  });
}

class QuizQuestionResult {
  final int questionIndex;
  final bool isCorrect;
  final int starsEarned;
  final int? timeRemaining;
  final bool hintUsed; // Track if -5 stars should be displayed

  QuizQuestionResult({
    required this.questionIndex,
    required this.isCorrect,
    required this.starsEarned,
    this.timeRemaining,
    this.hintUsed = false,
  });
}

class ShapeOption {
  final String id;
  final String name;
  final String imagePath; // e.g. 'assets/shapes/circle_red.png'

  const ShapeOption({
    required this.id,
    required this.name,
    required this.imagePath,
  });
}
