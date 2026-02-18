import 'dart:math';

class PseudoGenerator {
  static const List<String> _words = [
    'LAPIN', 'CHIEN', 'CHAT', 'LOUP', 'SINGE', 'TIGRE', 'KOALA', 'ZÉBRE', 
    'AIGLE', 'HIBOU', 'PERRO', 'PIE', 'CORBO', 'PIGEON', 'CANAR', 'CYGNE',
    'TULIP', 'ROSE', 'LILAS', 'LOTUS', 'COQUEL', 'SOUCI', 'MUGEA', 'ORCHI'
  ];

  static String generate() {
    final random = Random();
    String word = _words[random.nextInt(_words.length)];
    
    // Convert to Mixed Case (ex: Lapin instead of LAPIN)
    word = word[0].toUpperCase() + word.substring(1).toLowerCase();

    // Ensure 5 letters strictly (pad or truncate)
    if (word.length > 5) {
      word = word.substring(0, 5);
    } else while (word.length < 5) {
      word += 'x';
    }

    final numbers = random.nextInt(9000) + 1000; // 4 digits
    return '$word$numbers';
  }
}
