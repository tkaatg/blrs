import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import '../models/quiz_model.dart';
import 'dart:math';

class SignService {
  static List<Question> _allQuestions = [];

  static Future<void> loadSigns() async {
    if (_allQuestions.isNotEmpty) return;

    try {
      // 1. Try to load from Local JSON (converted from CSV for robustness)
      final String jsonData = await rootBundle.loadString('assets/data/panneaux.json');
      final List<dynamic> list = json.decode(jsonData);
      
      _allQuestions = list.map((item) {
        final String shapeId = (item['formeId'] ?? 'indication').toString().toLowerCase().trim();
        final String contentPath = item['contentImageUrl'] ?? '';
        final String fullPath = item['imageUrl'] ?? '';
        
        SignCategory category = SignCategory.indication;
        if (shapeId.contains('danger')) category = SignCategory.danger;
        else if (shapeId.contains('interdiction')) category = SignCategory.restriction;
        else if (shapeId.contains('obligation')) category = SignCategory.obligation;

        return Question(
          id: item['panneauId'] ?? 'Unknown',
          text: 'Quelle forme est associée à ce panneau ?',
          signContentImage: contentPath.startsWith('assets/') ? contentPath : 'assets/$contentPath',
          fullSignImage: fullPath.startsWith('assets/') ? fullPath : 'assets/$fullPath',
          correctShapeId: shapeId,
          distractorShapeIds: [],
          category: category,
          hintLabel: _getHintLabel(shapeId),
        );
      }).toList();

      debugPrint('SignService: Loaded ${_allQuestions.length} questions from JSON.');
    } catch (e, stack) {
      debugPrint('SignService: Error loading JSON, falling back to emergency questions: $e');
      _allQuestions = _getFallbackQuestions(10);
      debugPrint(stack.toString());
    }
  }

  static List<Question> getQuestionsForLevel(int levelId, {int count = 10}) {
    if (_allQuestions.isEmpty) {
      return _getFallbackQuestions(count);
    }
    List<Question> questions = List.from(_allQuestions);
    questions.shuffle();
    return questions.take(count).toList();
  }

  static List<Question> _getFallbackQuestions(int count) {
    final fallbacks = [
      Question(id: 'RS_001', text: 'Quelle forme est associée à ce panneau ?', signContentImage: 'assets/images/panneaux/RS_001q.png', fullSignImage: 'assets/images/panneaux/RS_001.png', correctShapeId: 'danger', distractorShapeIds: [], category: SignCategory.danger, hintLabel: 'DANGER'),
      Question(id: 'RS_002', text: 'Quelle forme est associée à ce panneau ?', signContentImage: 'assets/images/panneaux/RS_002q.png', fullSignImage: 'assets/images/panneaux/RS_002.png', correctShapeId: 'interdiction', distractorShapeIds: [], category: SignCategory.restriction, hintLabel: 'INTERDICTION'),
      Question(id: 'RS_003', text: 'Quelle forme est associée à ce panneau ?', signContentImage: 'assets/images/panneaux/RS_003q.png', fullSignImage: 'assets/images/panneaux/RS_003.png', correctShapeId: 'interdiction_barre', distractorShapeIds: [], category: SignCategory.restriction, hintLabel: 'INTERDICTION BARRÉE'),
      Question(id: 'RS_004', text: 'Quelle forme est associée à ce panneau ?', signContentImage: 'assets/images/panneaux/RS_004q.png', fullSignImage: 'assets/images/panneaux/RS_004.png', correctShapeId: 'interdiction_barre', distractorShapeIds: [], category: SignCategory.restriction, hintLabel: 'INTERDICTION BARRÉE'),
      Question(id: 'RS_005', text: 'Quelle forme est associée à ce panneau ?', signContentImage: 'assets/images/panneaux/RS_005q.png', fullSignImage: 'assets/images/panneaux/RS_005.png', correctShapeId: 'interdiction_barre', distractorShapeIds: [], category: SignCategory.restriction, hintLabel: 'INTERDICTION BARRÉE'),
      Question(id: 'RS_014', text: 'Quelle forme est associée à ce panneau ?', signContentImage: 'assets/images/panneaux/RS_014q.png', fullSignImage: 'assets/images/panneaux/RS_014.png', correctShapeId: 'obligation', distractorShapeIds: [], category: SignCategory.obligation, hintLabel: 'OBLIGATION'),
      Question(id: 'RS_035', text: 'Quelle forme est associée à ce panneau ?', signContentImage: 'assets/images/panneaux/RS_035q.png', fullSignImage: 'assets/images/panneaux/RS_035.png', correctShapeId: 'interdiction', distractorShapeIds: [], category: SignCategory.restriction, hintLabel: 'INTERDICTION'),
      Question(id: 'RS_036', text: 'Quelle forme est associée à ce panneau ?', signContentImage: 'assets/images/panneaux/RS_036q.png', fullSignImage: 'assets/images/panneaux/RS_036.png', correctShapeId: 'interdiction', distractorShapeIds: [], category: SignCategory.restriction, hintLabel: 'INTERDICTION'),
      Question(id: 'RS_024', text: 'Quelle forme est associée à ce panneau ?', signContentImage: 'assets/images/panneaux/RS_024q.png', fullSignImage: 'assets/images/panneaux/RS_024.png', correctShapeId: 'interdiction', distractorShapeIds: [], category: SignCategory.restriction, hintLabel: 'INTERDICTION'),
      Question(id: 'RS_025', text: 'Quelle forme est associée à ce panneau ?', signContentImage: 'assets/images/panneaux/RS_025q.png', fullSignImage: 'assets/images/panneaux/RS_025.png', correctShapeId: 'fin_obligation', distractorShapeIds: [], category: SignCategory.obligation, hintLabel: "FIN D'OBLIGATION"),
    ];
    fallbacks.shuffle();
    return fallbacks.take(count).toList();
  }

  static String _getHintLabel(String shapeId) {
    shapeId = shapeId.toLowerCase();
    if (shapeId.contains('danger')) return 'DANGER';
    if (shapeId.contains('interdiction_barre')) return 'INTERDICTION BARRÉE';
    if (shapeId.contains('fin_interdiction')) return "FIN D'INTERDICTION";
    if (shapeId.contains('interdiction')) return 'INTERDICTION';
    if (shapeId.contains('fin_obligation')) return "FIN D'OBLIGATION";
    if (shapeId.contains('obligation')) return 'OBLIGATION';
    if (shapeId.contains('fin_indication')) return "FIN D'INDICATION";
    if (shapeId.contains('indication')) return 'INDICATION';
    if (shapeId.contains('special') || shapeId.contains('stop')) return 'SPECIAL';
    return 'INDICATION';
  }
}
