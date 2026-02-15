import 'package:flutter_test/flutter_test.dart';
import 'package:baby_learning_road_signs/services/utils/pseudo_generator.dart';

void main() {
  group('PseudoGenerator Tests', () {
    test('Generated pseudo should follow the format NATUREWORD + 4 digits', () {
      final pseudo = PseudoGenerator.generate();
      
      // Check length: 6 letters + 4 digits = 10 characters
      expect(pseudo.length, 10);
      
      // Check first 6 characters are uppercase letters
      final lettersPart = pseudo.substring(0, 6);
      expect(RegExp(r'^[A-Z]+$').hasMatch(lettersPart), true);
      
      // Check last 4 characters are digits
      final digitsPart = pseudo.substring(6);
      expect(RegExp(r'^\d{4}$').hasMatch(digitsPart), true);
    });

    test('Generated pseudos should be somewhat random', () {
      final pseudo1 = PseudoGenerator.generate();
      final pseudo2 = PseudoGenerator.generate();
      
      expect(pseudo1, isNot(pseudo2));
    });
  });
}
