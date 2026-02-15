import 'dart:math';

class PseudoGenerator {
  static const List<String> _words = [
    // Animals (6 letters)
    'GIRAFE', 'POULPE', 'PHOQUE', 'COUGAR', 'RENARD', 'CASTOR', 
    'FOURMI', 'REQUIN', 'LOUPES', 'TIGRES', 'KOALAS', 'FAUCON',
    // Flowers (6 letters)
    'TULIPE', 'DAHLIA', 'JASMIN', 'ORCHIS', 'MUGUET', 'AVOINE',
    'PENSEE', 'SOUCIS', 'YUCCAS', 'ARRETE', 'CERISE', 'PRUNES'
  ];

  static String generate() {
    final random = Random();
    final word = _words[random.nextInt(_words.length)];
    final numbers = random.nextInt(9000) + 1000; // 4 digits (1000 to 9999)
    return '$word$numbers';
  }
}
