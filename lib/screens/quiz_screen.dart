import 'package:flutter/material.dart';
import 'dart:async';
import '../models/quiz_model.dart';
import '../models/player_model.dart';
import '../services/sign_service.dart';
import '../widgets/bubbly_title.dart';
import '../widgets/bubbly_button.dart';

class QuizScreen extends StatefulWidget {
  final Player player;
  final int levelId;
  final bool isFree;
  final Function(int, int)? onComplete;

  const QuizScreen({
    super.key,
    required this.player,
    required this.levelId,
    this.isFree = false,
    this.onComplete,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

enum QuizState { intro, questioning, feedback, results }

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  QuizState _currentState = QuizState.intro;
  int _currentQuestionIndex = 0;
  List<QuizQuestionResult> _results = [];
  
  // Timer logic
  late AnimationController _timerController;
  int _secondsRemaining = 15;
  Timer? _countdownTimer;

  // Quiz Mock Data
  late List<Question> _questions;
  
  bool _hintUsed = false;
  String? _selectedShapeId;
  bool _isCorrectSelection = false;
  bool _isTimeout = false;
  List<String> _currentOptions = [];

  @override
  void initState() {
    super.initState();
    
    // Load real questions from CSV via SignService (fallback handled in service)
    _questions = SignService.getQuestionsForLevel(widget.levelId);

    _timerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    );

    // Start Intro -> then Question 1
    Future.delayed(const Duration(milliseconds: 500), () {
      _startQuestion();
    });
  }

  void _startQuestion() {
    final question = _currentQuestion;
    
    // 1. Group shapes by FAMILIES (Visual identity)
    // LOWERCASE keys to match SignService output
    final Map<String, List<String>> families = {
      'red_circle': ['interdiction'],
      'red_circle_barre': ['interdiction_barre', 'fin_interdiction'],
      'blue_circle_obligation': ['obligation'],
      'blue_circle_fin': ['fin_obligation'],
      'square': ['indication', 'fin_indication'],
      'triangle': ['danger', 'danger_permanent'],
      'special': ['special_stop']
    };

    String getFamilyKey(String id) {
      String lid = id.toLowerCase();
      for (var entry in families.entries) {
        if (entry.value.contains(lid)) return entry.key;
      }
      return 'special';
    }

    String correctId = question.correctShapeId.toLowerCase();
    String correctFamily = getFamilyKey(correctId);
    
    // 2. Select distractors from DIFFERENT families only to avoid visual duplicates
    Set<String> optionsIds = {correctId}; // GUARANTEED SOLUTION
    
    List<String> otherFamilyKeys = families.keys.toList()..remove(correctFamily);
    otherFamilyKeys.shuffle();

    for (String familyKey in otherFamilyKeys) {
      if (optionsIds.length >= 3) break;
      List<String> members = List.from(families[familyKey]!)..shuffle();
      if (members.isNotEmpty) {
        optionsIds.add(members.first);
      }
    }
    
    // NO PLAN B as requested by CTO. 
    // If data is missing, we must know.
    if (optionsIds.length < 3) {
      debugPrint('CRITICAL: Not enough distractors for $correctId in $correctFamily');
      // Still need to guarantee 3 for UI not to crash, 
      // but we use distinctive placeholders to make the bug obvious
      while (optionsIds.length < 3) {
        optionsIds.add('error_${optionsIds.length}');
      }
    }

    _currentOptions = optionsIds.toList();
    _currentOptions.shuffle();

    debugPrint('Quiz - Q${_currentQuestionIndex + 1}: Correct=$correctId, Options=$_currentOptions');

    setState(() {
      _currentState = QuizState.questioning;
      _hintUsed = false;
      _selectedShapeId = null;
      _isCorrectSelection = false;
      _isTimeout = false;
      _secondsRemaining = 15;
    });

    _timerController.reset();
    _timerController.forward();
    
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        if (mounted) setState(() => _secondsRemaining--);
      } else {
        _handleTimeout();
      }
    });
  }

  void _handleSelection(String shapeId) {
    if (_currentState != QuizState.questioning) return;
    
    _countdownTimer?.cancel();
    _timerController.stop();

    final isCorrect = shapeId == _questions[_currentQuestionIndex].correctShapeId;
    
    setState(() {
      _selectedShapeId = shapeId;
      _isCorrectSelection = isCorrect;
      _currentState = QuizState.feedback;
    });

    // Record result
    int bonus = (isCorrect && !widget.isFree) ? (_secondsRemaining * 10) : 0;
    _results.add(QuizQuestionResult(
      questionIndex: _currentQuestionIndex,
      isCorrect: isCorrect,
      starsEarned: bonus,
      timeRemaining: _secondsRemaining,
      hintUsed: _hintUsed,
    ));
  }

  void _handleTimeout() {
    _countdownTimer?.cancel();
    _timerController.stop();

    setState(() {
      _isTimeout = true;
      _currentState = QuizState.feedback;
    });

    _results.add(QuizQuestionResult(
      questionIndex: _currentQuestionIndex,
      isCorrect: false,
      starsEarned: widget.isFree ? 0 : -5,
      timeRemaining: 0,
    ));
  }

  void _useHint() {
    if (_hintUsed || _currentState != QuizState.questioning) return;
    setState(() {
      _hintUsed = true;
      // Deduct 5 stars logic would be here in a real provider
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
      _startQuestion();
    } else {
      setState(() {
        _currentState = QuizState.results;
      });
    }
  }

  // Safety wrapper for build
  Question get _currentQuestion {
    if (_questions.isEmpty) {
       return Question(id: 'RS_002', text: 'Quelle forme est associée à ce panneau ?', signContentImage: 'assets/images/panneaux/RS_002q.png', fullSignImage: 'assets/images/panneaux/RS_002.png', correctShapeId: 'interdiction', distractorShapeIds: [], category: SignCategory.restriction, hintLabel: 'INTERDICTION');
    }
    int safeIndex = _currentQuestionIndex.clamp(0, _questions.length - 1);
    return _questions[safeIndex];
  }

  @override
  void dispose() {
    _timerController.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, 
      body: Stack(
        children: [
          // FULL SCREEN BACKGROUND (THE CITY & ROAD IMAGE)
          Positioned.fill(
            child: Image.asset(
              _currentState == QuizState.questioning 
                  ? 'assets/images/fond-anime.gif' 
                  : 'assets/images/quiz_background.png',
              fit: BoxFit.cover,
            ),
          ),
          
          // QUIZ CONTENT OVERLAY
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: _currentState == QuizState.results 
                  ? Container(
                      margin: const EdgeInsets.only(top: 140), // Increased to definitely avoid TopBar
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: _buildResultsView()) 
                  : _buildQuizView(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizView() {
    final question = _currentQuestion;
    
    return Column(
      children: [
        // 1. TOP SPACE (For the main nav chips)
        const SizedBox(height: 50),

        // 2. THE SIGN (Floating) - Reduced flex to occupy less vertical space
        Expanded(
          flex: 3, 
          child: Stack(
            children: [
              // Sign on the right
              Positioned(
                right: 30,
                bottom: 10, // Slightly lower
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.black, width: 3),
                        boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 10)],
                      ),
                      child: Image.asset(
                        _currentState == QuizState.feedback || _isTimeout 
                            ? question.fullSignImage 
                            : question.signContentImage,
                        width: 90, // Slightly smaller
                        height: 90,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => 
                            const Icon(Icons.warning_amber_rounded, size: 60, color: Colors.blue),
                      ),
                    ),
                    Container(
                      width: 10,
                      height: 70, // Reduced height for the post
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // 3. THE QUESTION TEXT (Small white box)
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
          ),
          child: Text(
            '${_currentQuestionIndex + 1}/${_questions.length} : Quelle forme est associée à ce panneau ?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width < 400 ? 14 : 16, // Adaptive font size
              fontWeight: FontWeight.bold, 
              color: Colors.black87
            ),
          ),
        ),

        const SizedBox(height: 10), // Reduced spacing

        // 4. OPTIONS BOX (Solid bottom panel)
        Container(
          padding: const EdgeInsets.all(15), // Reduced padding
          decoration: BoxDecoration(
            color: const Color(0xFF00382B), // Fully solid to hide road behind it
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 15)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Takes minimal space
            children: [
              // OPTIONS GRID
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _currentOptions.map((shapeId) {
                  final isSelected = _selectedShapeId == shapeId;
                  final isCorrect = shapeId == question.correctShapeId;
                  
                  Color borderColor = Colors.black12;
                  if (_currentState == QuizState.feedback) {
                    if (isCorrect) borderColor = Colors.green;
                    else if (isSelected) borderColor = Colors.red;
                  } else if (isSelected) {
                    borderColor = Colors.amber;
                  }

                  return GestureDetector(
                    onTap: () => _handleSelection(shapeId),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.25, // Responsive width
                      height: MediaQuery.of(context).size.width * 0.25,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: borderColor, width: 4),
                        boxShadow: [
                           BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5)
                        ],
                      ),
                      child: Image.asset(
                        _getShapeImagePath(shapeId),
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => 
                            const Icon(Icons.help_outline, size: 40),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 10),

              // BOTTOM INFO PANEL
              Container(
                constraints: const BoxConstraints(minHeight: 80),
                child: Row(
                  children: [
                    // TIMER
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.blue.shade900, width: 2),
                      ),
                      child: Text(
                        '00:${_secondsRemaining.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          fontSize: 20, 
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Courier',
                          color: _secondsRemaining < 5 ? Colors.red : Colors.black,
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    // MESSAGE / ACTION AREA
                    Expanded(
                      child: _currentState == QuizState.feedback 
                          ? _buildFeedbackArea(question)
                          : _buildHintArea(question),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getHintColor(Question q) {
    String sid = q.correctShapeId.toLowerCase();
    if (sid.contains('interdiction') || sid.contains('danger')) {
      if (sid.contains('fin_interdiction')) return Colors.black;
      return Colors.red;
    }
    if (sid.contains('indication') || sid.contains('obligation')) return Colors.blue;
    return Colors.black;
  }

  String _getShapeImagePath(String id) {
    String lid = id.toLowerCase();
    switch (lid) {
      case 'danger':
      case 'danger_permanent': 
        return 'assets/images/shapes/danger_permanent.png';
      case 'interdiction': 
        return 'assets/images/shapes/interdiction.png';
      case 'interdiction_barre': 
        return 'assets/images/shapes/interdiction_barre.png';
      case 'fin_interdiction':
        return 'assets/images/shapes/fin_interdiction.png';
      case 'obligation': 
        return 'assets/images/shapes/obligation.png';
      case 'fin_obligation':
        return 'assets/images/shapes/fin_obligation.png';
      case 'indication': 
        return 'assets/images/shapes/indication.png';
      case 'fin_indication':
        return 'assets/images/shapes/fin_indication.png';
      case 'special_stop':
        return 'assets/images/shapes/special_stop.png';
      default: 
        return 'assets/images/shapes/indication.png';
    }
  }

  Widget _buildHintArea(Question question) {
    return Center(
      child: GestureDetector(
        onTap: _useHint,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: _hintUsed ? Colors.white : const Color(0xFFFFB900), // Jaune Ergo DS
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, offset: const Offset(0, 4))],
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'INDICE ', 
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)
                ),
                if (_hintUsed)
                  Text(
                    ': ${question.hintLabel}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: _getHintColor(question))
                  )
                else if (!widget.isFree) ...[
                  const Text('- 5', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const Icon(Icons.star, color: Colors.white, size: 18),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeedbackArea(Question question) {
    String message = "";
    Color msgColor = Colors.white;
    int? stars;

    if (_isTimeout) {
      message = "Temps écoulé !";
      msgColor = Colors.orange.shade200;
    } else if (_isCorrectSelection) {
      stars = _secondsRemaining * 10;
      message = "Gagné ! +$stars";
      msgColor = const Color(0xFF7FBA00); // Vert Ergo DS
    } else {
      message = "Presque !";
      msgColor = Colors.red.shade200;
    }

    return Row(
      children: [
        // MESSAGE
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                message, 
                style: TextStyle(color: msgColor, fontSize: 18, fontWeight: FontWeight.bold)
              ),
              if (_isCorrectSelection) ...[
                const SizedBox(width: 4),
                const Icon(Icons.star, color: Color(0xFFFFB900), size: 22),
              ],
            ],
          ),
        ),
        
        // NEXT BUTTON (CTA XXL)
        ElevatedButton(
          onPressed: _nextQuestion,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF25022), // Orange Ergo DS
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: const BorderSide(color: Colors.white, width: 2),
            ),
            elevation: 8,
          ),
          child: const Text('Suivant', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildResultsView() {
    int totalStars = _results.fold(0, (sum, item) {
      int gain = item.isCorrect ? item.starsEarned : 0;
      int loss = item.hintUsed ? 5 : 0;
      return sum + gain - loss;
    });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      child: Column(
        children: [
          BubblyTitle(title: 'Niveau n°${widget.levelId}'),
          const SizedBox(height: 25),
          
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: _results.length,
              itemBuilder: (context, index) {
                final r = _results[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Question ${r.questionIndex + 1}', 
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Color(0xFF004D40))
                      ),
                      const Spacer(),
                      
                      // Result Circle (Status)
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: r.isCorrect ? const Color(0xFF7FBA00) : const Color(0xFFF25022),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)],
                        ),
                      ),
                      const SizedBox(width: 12),
                      
                      // Score & Penalty Area (Fixed width for perfect alignment)
                      SizedBox(
                        width: 90,
                        child: Row(
                          children: [
                            if (r.isCorrect) 
                              Text(
                                '+${r.starsEarned}', 
                                style: const TextStyle(fontSize: 18, color: Color(0xFF388E3C), fontWeight: FontWeight.w900)
                              ),
                            const Spacer(),
                            if (r.hintUsed) ...[
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                '- 5', 
                                style: TextStyle(fontSize: 14, color: Colors.red, fontWeight: FontWeight.bold)
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          
          const SizedBox(height: 20),

          // TOTAL CARD
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            decoration: BoxDecoration(
              color: const Color(0xFF00382B).withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF00382B).withOpacity(0.2), width: 2),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'TOTAL ', 
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF004D40))
                ),
                Text(
                  totalStars >= 0 ? '+ $totalStars' : '$totalStars',
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Color(0xFF004D40)),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.star, color: Colors.amber, size: 36),
              ],
            ),
          ),
          
          const SizedBox(height: 25),
          
          // RETOUR BUTTON
          BubblyButton(
            onTap: () {
              int correctCount = _results.where((r) => r.isCorrect).length;
              if (widget.onComplete != null) widget.onComplete!(correctCount, totalStars);
            },
            color: Colors.amber,
            height: 65,
            child: const Text(
              'RETOUR', 
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white)
            ),
          ),
        ],
      ),
    );
  }
}
