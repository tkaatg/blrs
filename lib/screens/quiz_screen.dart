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
  final Function(int, int)? onComplete;   // (correctCount, totalStars)
  final Function(int)? onStarsEarned;     // called immediately when results screen appears
  final VoidCallback? onReplay;           // called when player taps "Rejouer"

  const QuizScreen({
    super.key,
    required this.player,
    required this.levelId,
    this.isFree = false,
    this.onComplete,
    this.onStarsEarned,
    this.onReplay,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

enum QuizState { intro, questioning, feedback, results }
enum IntroStep { countdown, showSign, showMessage, casinoRolling, none }

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  QuizState _currentState = QuizState.intro;
  IntroStep _introStep = IntroStep.countdown;
  int _currentQuestionIndex = 0;
  List<QuizQuestionResult> _results = [];
  bool _isFirstQuestion = true; // countdown shown only on the first question
  
  // Animation controllers
  late AnimationController _timerController;
  late AnimationController _pulseController;
  late AnimationController _casinoController;
  late AnimationController _roadController; // road scroll animation
  
  int _secondsRemaining = 15;
  int _introCountdown = 3; 
  int _gifSeed = 0; // incremented each question to bust browser GIF cache
  Timer? _countdownTimer;
  Timer? _introTimer;

  // Quiz Data
  late List<Question> _questions;
  
  bool _hintUsed = false;
  String? _selectedShapeId;
  bool _isCorrectSelection = false;
  bool _isTimeout = false;
  List<String> _currentOptions = [];
  List<String> _casinoDisplayOptions = ['', '', '']; 
  bool _rolling1 = false;
  bool _rolling2 = false;
  bool _rolling3 = false;

  @override
  void initState() {
    super.initState();
    _questions = SignService.getQuestionsForLevel(widget.levelId);

    _timerController = AnimationController(vsync: this, duration: const Duration(seconds: 15));
    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600))..repeat(reverse: true);
    _casinoController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    // Road scroll: loops every 1.5s so it feels like the car is approaching
    _roadController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..repeat();

    _startIntroSequence();
  }

  @override
  void dispose() {
    _timerController.dispose();
    _pulseController.dispose();
    _casinoController.dispose();
    _roadController.dispose();
    _casinoFrameTimer?.cancel();
    _countdownTimer?.cancel();
    _introTimer?.cancel();
    super.dispose();
  }

  // Casino frame counter for real 3fps throttle
  Timer? _casinoFrameTimer;
  int _casinoFrameIndex = 0;
  final List<String> _allShapes = ['interdiction', 'danger', 'indication', 'obligation', 'fin_interdiction', 'special_stop'];

  void _startIntroSequence() {
    if (!mounted) return;
    setState(() {
      _currentState = QuizState.intro;
      // Always start with countdown step – this hides sign content.
      // The countdown NUMBERS are only rendered when _isFirstQuestion is true.
      _introStep = IntroStep.countdown;
      _introCountdown = 3; 
      _gifSeed++;          // new seed → Image.network cache-busts the GIF
      _selectedShapeId = null;
      _isCorrectSelection = false;
      _isTimeout = false;
      _hintUsed = false;
      _casinoDisplayOptions = ['', '', ''];
    });

    _setupQuestionOptions();

    if (_isFirstQuestion) {
      // First question: show 3-2-1 countdown then reveal sign
      _introTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_introCountdown > 1) {
          if (mounted) setState(() => _introCountdown--);
        } else {
          timer.cancel();
          _isFirstQuestion = false;
          _revealSign();
        }
      });
    } else {
      // Subsequent questions: GIF plays for 3s (panel hidden), then reveal sign + casino
      Future.delayed(const Duration(seconds: 3), () {
        if (!mounted) return;
        _revealSign();
      });
    }
  }

  void _setupQuestionOptions() {
    final question = _currentQuestion;
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
    Set<String> optionsIds = {correctId};
    List<String> otherFamilyKeys = families.keys.toList()..remove(correctFamily);
    otherFamilyKeys.shuffle();

    for (String familyKey in otherFamilyKeys) {
      if (optionsIds.length >= 3) break;
      List<String> members = List.from(families[familyKey]!)..shuffle();
      if (members.isNotEmpty) optionsIds.add(members.first);
    }

    _currentOptions = optionsIds.toList()..shuffle();
  }

  void _revealSign() {
    if (!mounted) return;
    setState(() => _introStep = IntroStep.showSign);
    // Start casino immediately (no extra delay)
    _startCasinoSequenced();
  }

  void _startCasinoSequenced() {
    if (!mounted) return;
    setState(() {
      _introStep = IntroStep.casinoRolling;
      _rolling1 = true;
      _rolling2 = true;
      _rolling3 = true;
      _casinoFrameIndex = 0;
    });

    // 12 FPS = 83ms per frame
    _casinoFrameTimer?.cancel();
    _casinoFrameTimer = Timer.periodic(const Duration(milliseconds: 83), (timer) {
      if (!mounted) { timer.cancel(); return; }
      if (_introStep != IntroStep.casinoRolling) { timer.cancel(); return; }
      setState(() {
        _casinoFrameIndex++;
        if (_rolling1) _casinoDisplayOptions[0] = _allShapes[_casinoFrameIndex % _allShapes.length];
        if (_rolling2) _casinoDisplayOptions[1] = _allShapes[(_casinoFrameIndex + 2) % _allShapes.length];
        if (_rolling3) _casinoDisplayOptions[2] = _allShapes[(_casinoFrameIndex + 4) % _allShapes.length];
      });
    });
    
    // T+1s: stop rolling 1
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (!mounted) return;
      setState(() {
        _rolling1 = false;
        _casinoDisplayOptions[0] = _currentOptions[0];
      });
    });

    // T+1.5s: stop rolling 2
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() {
        _rolling2 = false;
        _casinoDisplayOptions[1] = _currentOptions[1];
      });
    });

    // T+2s: stop rolling 3 and start quiz
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (!mounted) return;
      _casinoFrameTimer?.cancel();
      setState(() {
        _rolling3 = false;
        _casinoDisplayOptions[2] = _currentOptions[2];
        _introStep = IntroStep.none;
        _currentState = QuizState.questioning;
        _startTimer();
      });
    });
  }

  void _startTimer() {
    _secondsRemaining = 15;
    _timerController.reset();
    _timerController.forward();
    
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        if (mounted) setState(() => _secondsRemaining--);
      } else {
        timer.cancel();
        _handleTimeout();
      }
    });
  }

  void _handleSelection(String shapeId) {
    if (_currentState != QuizState.questioning) return;

    _countdownTimer?.cancel();
    _timerController.stop();

    final isCorrect = shapeId.toLowerCase() == _currentQuestion.correctShapeId.toLowerCase();
    
    setState(() {
      _selectedShapeId = shapeId;
      _isCorrectSelection = isCorrect;
      _currentState = QuizState.feedback;
    });

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

    // BUG FIX: record hintUsed so the -20★ deduction is applied even on timeout
    _results.add(QuizQuestionResult(
      questionIndex: _currentQuestionIndex,
      isCorrect: false,
      starsEarned: 0,
      timeRemaining: 0,
      hintUsed: _hintUsed,
    ));
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      if (mounted) {
        setState(() {
          _currentQuestionIndex++;
        });
        _startIntroSequence();
      }
    } else {
      if (mounted) {
        // Compute net stars immediately and credit them before showing results
        final int hintsUsed = _results.where((r) => r.hintUsed).length;
        final int gross = _results.fold(0, (sum, r) => sum + r.starsEarned);
        final int net = (gross - hintsUsed * 20).clamp(0, 999999);
        widget.onStarsEarned?.call(net);
        setState(() {
          _currentState = QuizState.results;
        });
      }
    }
  }

  Question get _currentQuestion {
    if (_questions.isEmpty) {
       return Question(id: 'RS_002', text: 'Quelle forme a ce panneau ?', signContentImage: 'assets/images/panneaux/RS_002q.png', fullSignImage: 'assets/images/panneaux/RS_002.png', correctShapeId: 'interdiction', distractorShapeIds: [], category: SignCategory.restriction, hintLabel: 'INTERDICTION');
    }
    int safeIndex = _currentQuestionIndex.clamp(0, _questions.length - 1);
    return _questions[safeIndex];
  }

  @override
  Widget build(BuildContext context) {
    if (_currentState == QuizState.results) {
      return _buildResultsScreen();
    }

    final question = _currentQuestion;
    // On wide screens, constrain content to 600px centered
    final double maxW = MediaQuery.of(context).size.width;
    final double contentWidth = maxW > 600 ? 600.0 : maxW;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            // Animated road background: GIF reloaded each question via Image.network
            // with a seed query param to bust the browser cache.
            Positioned.fill(
              child: Image.network(
                key: ValueKey(_gifSeed), // KEY change forces widget rebuild → GIF restarts
                'assets/images/fond-anime.gif?t=$_gifSeed',
                fit: BoxFit.cover,
                errorBuilder: (ctx, e, st) => Image.asset(
                  key: ValueKey('asset_$_gifSeed'),
                  'assets/images/fond-anime.gif',
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Centered content column constrained to 600px
            Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: contentWidth,
                height: constraints.maxHeight,
                child: SafeArea(
                  child: Column(
                    children: [
                      // 1. TOP SPACE (to clear pseudo/stars bar)
                      const SizedBox(height: 60),

                      // 2. THE SIGN SECTION (expanded to fill middle area)
                      _buildSignSection(question),

                      // 3. OPTIONS BOX (question label now inside this box)
                      _buildOptionsBox(question),
                    ],
                  ),
                ),
              ),
            ),

            // COUNTDOWN OVERLAY – only shown on first question (numbers 3-2-1)
            if (_introStep == IntroStep.countdown && _isFirstQuestion)
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 90),
                  child: AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      final colors = [Colors.red, Colors.amber, Colors.deepOrangeAccent];
                      final shadowColors = [Colors.red.shade900, Colors.orange.shade900, Colors.deepOrange.shade900];
                      final ci = (_introCountdown - 1).clamp(0, 2);
                      final scale = 1.0 + (_pulseController.value * 0.35);
                      final opacity = 0.85 + (_pulseController.value * 0.15);
                      return Opacity(
                        opacity: opacity,
                        child: Transform.scale(
                          scale: scale,
                          child: Text(
                            '$_introCountdown',
                            style: TextStyle(
                              fontSize: 140,
                              fontWeight: FontWeight.w900,
                              color: colors[ci],
                              shadows: [
                                Shadow(blurRadius: 0, color: colors[ci].withOpacity(0.6), offset: const Offset(4, 4)),
                                Shadow(blurRadius: 40, color: shadowColors[ci]),
                                const Shadow(blurRadius: 60, color: Colors.black87),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

            // FEEDBACK OVERLAY – same sky position as countdown, shown when feedback state
            if (_currentState == QuizState.feedback)
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 80),
                  child: AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      String msg;
                      Color color;
                        if (_isTimeout) {
                        msg = '⏱';
                        color = Colors.orange;
                      } else if (_isCorrectSelection) {
                        msg = '🏆';
                        color = Colors.amber;
                      } else {
                        msg = '😅';
                        color = Colors.redAccent;
                      }
                      final String label = _isTimeout
                          ? 'Temps terminé !'
                          : _isCorrectSelection
                              ? 'Gagné !'
                              : 'Perdu...';
                      final scale = 1.0 + (_pulseController.value * 0.15);
                      return Transform.scale(
                        scale: scale,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              msg,
                              style: const TextStyle(fontSize: 70),
                            ),
                            Text(
                              label,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w900,
                                color: color,
                                shadows: [
                                  Shadow(blurRadius: 0, color: color.withOpacity(0.5), offset: const Offset(3, 3)),
                                  const Shadow(blurRadius: 30, color: Colors.black87),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),

          ],
        );
      },
    );
  }

  Widget _buildSignSection(Question question) {
    bool showContent = _introStep != IntroStep.countdown;
    const double signSize = 140.0;

    return Expanded(
      flex: 3,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Sign + pole, positioned right-center of available space
          Positioned(
            right: 30,
            bottom: 30,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Octagonal sign zone with dotted border
                SizedBox(
                  width: signSize,
                  height: signSize,
                  child: CustomPaint(
                    painter: OctagonSignPainter(
                      borderColor: Colors.grey.shade400,
                      fillColor: Colors.white,
                    ),
                    child: Center(
                      child: SizedBox(
                        width: signSize * 0.7,
                        height: signSize * 0.7,
                        child: showContent
                            ? TweenAnimationBuilder(
                                duration: const Duration(milliseconds: 600),
                                tween: Tween<double>(begin: 0.0, end: 1.0),
                                curve: Curves.elasticOut,
                                builder: (context, value, child) =>
                                    Transform.scale(scale: value, child: child),
                                child: Image.asset(
                                  _currentState == QuizState.feedback || _isTimeout
                                      ? question.fullSignImage
                                      : question.signContentImage,
                                  fit: BoxFit.contain,
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ),
                  ),
                ),
                // Pole
                Container(
                  width: 12,
                  height: 55,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.grey[800]!, Colors.grey[600]!],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionLabel() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Quiz ${widget.levelId}  –  Question ${_currentQuestionIndex + 1} / ${_questions.length}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.white70,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Trouve la forme du panneau !',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              shadows: [Shadow(blurRadius: 4, color: Colors.black54)],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionsBox(Question question) {
    // Shapes are only tappable once the casino animation is done (IntroStep.none)
    final bool shapesReady = _introStep == IntroStep.none || _currentState == QuizState.feedback;
    final bool isIntroRunning = _introStep == IntroStep.casinoRolling;

    return LayoutBuilder(
      builder: (context, constraints) {
        // 3 cards + 2 gaps of 20px each
        const double gap = 20.0;
        final double cardSize = (constraints.maxWidth - 24 - gap * 2) / 3;

        return Container(
          padding: const EdgeInsets.only(top: 12, left: 12, right: 12, bottom: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF00382B).withOpacity(0.93),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
            boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 20)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Question label: always visible, text updates after each question
              _buildQuestionLabel(),

              // 3 option cards with visible dark gap between them
              Row(
                children: () {
                  final List<Widget> items = [];
                  for (int index = 0; index < 3; index++) {
                    final shapeId = isIntroRunning
                        ? (_casinoDisplayOptions.length > index ? _casinoDisplayOptions[index] : '')
                        : (shapesReady && _currentOptions.length > index ? _currentOptions[index] : '');

                    final isSelected = _selectedShapeId == shapeId && shapeId.isNotEmpty;
                    final isCorrect = shapeId.isNotEmpty &&
                        shapeId.toLowerCase() == question.correctShapeId.toLowerCase();

                    Widget? feedbackBorder;
                    if (_currentState == QuizState.feedback && shapeId.isNotEmpty) {
                      if (_isTimeout && isCorrect) {
                        feedbackBorder = AnimatedBlinkingBorder(color: Colors.orange, thickness: 8);
                      } else if (isSelected && _isCorrectSelection && isCorrect) {
                        feedbackBorder = AnimatedBlinkingBorder(color: const Color(0xFF7FBA00), thickness: 8);
                      } else if (isSelected && !_isCorrectSelection) {
                        feedbackBorder = AnimatedBlinkingBorder(color: Colors.redAccent, thickness: 8);
                      }
                    }

                    if (index > 0) items.add(const SizedBox(width: gap));
                    items.add(Expanded(
                      child: GestureDetector(
                        onTap: shapesReady ? () => _handleSelection(shapeId) : null,
                        child: Container(
                          height: cardSize,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8)],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              if (shapeId.isNotEmpty)
                                Image.asset(_getShapeImagePath(shapeId), fit: BoxFit.contain),
                              if (feedbackBorder != null) Positioned.fill(child: feedbackBorder),
                            ],
                          ),
                        ),
                      ),
                    ));
                  }
                  return items;
                }(),
              ),
              const SizedBox(height: 14),
              _buildInfoRow(question),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(Question question) {
    // Determine feedback message
    String? feedbackMsg;
    Color feedbackColor = Colors.green;
    if (_currentState == QuizState.feedback) {
      if (_isTimeout) {
        feedbackMsg = '⏱ Temps terminé !';
        feedbackColor = Colors.orange;
      } else if (_isCorrectSelection) {
        feedbackMsg = '🎉 Gagné !';
        feedbackColor = const Color(0xFF7FBA00);
      } else {
        feedbackMsg = '❌ Perdu...';
        feedbackColor = Colors.redAccent;
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Fixed-height feedback zone: minimal spacer (messages are in sky overlay)
        const SizedBox(height: 8),
        // Timer + button row
        SizedBox(
          height: 66,
          child: Row(
            children: [
              // Animated timer SS:CC using _timerController value
              AnimatedBuilder(
                animation: _timerController,
                builder: (context, child) {
                  // On timeout: always show 00:00
                  if (_isTimeout) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.red, width: 3),
                      ),
                      child: const Text(
                        '00:00',
                        style: TextStyle(color: Colors.red, fontSize: 30, fontWeight: FontWeight.w900, fontFamily: 'Courier'),
                      ),
                    );
                  }
                  final remaining = (1.0 - _timerController.value) * 15.0;
                  final s = remaining.floor().clamp(0, 15);
                  final cs = ((remaining - remaining.floor()) * 100).toInt().clamp(0, 99);
                  final isLow = s < 5;
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: isLow ? Colors.red : Colors.blue.shade900, width: 3),
                    ),
                    child: Text(
                      '${s.toString().padLeft(2, '0')}:${cs.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        color: isLow ? Colors.red : Colors.blue.shade900,
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Courier',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _currentState == QuizState.feedback
                    ? _buildFeedbackButton()
                    : _buildHintButton(question),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeedbackButton() {
    return BubblyButton(
      color: const Color(0xFF0078D4),
      onTap: _nextQuestion,
      child: const Text('SUIVANT', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900)),
    );
  }

  Widget _buildHintButton(Question question) {
    // Hint is only usable once shapes are revealed (after casino animation)
    final bool canUseHint = _introStep == IntroStep.none && !_hintUsed && !widget.isFree;
    final bool shapesReady = _introStep == IntroStep.none;

    return BubblyButton(
      onTap: canUseHint ? () => setState(() => _hintUsed = true) : null,
      color: shapesReady ? Colors.orange : Colors.grey.shade600,
      child: FittedBox(
        child: Row(
          children: [
            Icon(Icons.lightbulb, color: shapesReady ? Colors.white : Colors.white38),
            const SizedBox(width: 8),
            Text(
              _hintUsed ? question.hintLabel : 'INDICE -20 ⭐',
              style: TextStyle(
                color: shapesReady ? Colors.white : Colors.white38,
                fontWeight: FontWeight.w900,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
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

  Widget _buildResultsScreen() {
    final int hintsUsed = _results.where((r) => r.hintUsed).length;
    final int gross = _results.fold(0, (sum, res) => sum + res.starsEarned);
    final int totalStars = (gross - hintsUsed * 20).clamp(0, 999999);
    int correctCount = _results.where((r) => r.isCorrect).length;
    final bool passed = correctCount >= 7;

    return Container(
      color: const Color(0xFF00382B).withOpacity(0.95),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               const SizedBox(height: 120),
               BubblyTitle(title: 'NIVEAU ${widget.levelId}'),
               const SizedBox(height: 30),
               
               // Summary Card
               Container(
                 margin: const EdgeInsets.symmetric(horizontal: 40),
                 padding: const EdgeInsets.all(24),
                 decoration: BoxDecoration(
                   color: Colors.white,
                   borderRadius: BorderRadius.circular(30),
                   boxShadow: [const BoxShadow(color: Colors.black45, blurRadius: 15)],
                 ),
                 child: Column(
                   children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('$correctCount', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: Color(0xFF00382B))),
                          Text(' / ${_questions.length}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey)),
                        ],
                      ),
                      const Text('REPONSES CORRECTES', style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      _buildResultDots(),
                      const Divider(height: 40, thickness: 1.5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('+$gross', style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: Colors.amber)),
                          const SizedBox(width: 8),
                          const Icon(Icons.star, color: Colors.amber, size: 40),
                        ],
                      ),
                      if (hintsUsed > 0) ...[  
                        const SizedBox(height: 4),
                        Text(
                          '-  ${hintsUsed * 20} ⭐ (${hintsUsed} indice${hintsUsed > 1 ? 's' : ''})',
                          style: const TextStyle(fontSize: 14, color: Colors.redAccent, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '= +$totalStars ⭐ crédités',
                          style: const TextStyle(fontSize: 14, color: Color(0xFF00A86B), fontWeight: FontWeight.w800),
                        ),
                      ],
                   ],
                 ),
               ),
               
               const SizedBox(height: 24),

               // Conditional result message
               Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 40),
                 child: Column(
                   children: [
                     Text(
                       passed ? '🏆 Bravo !' : '😅 Dommage !',
                       style: TextStyle(
                         fontSize: 28,
                         fontWeight: FontWeight.w900,
                         color: passed ? Colors.amber : Colors.orange,
                         shadows: const [Shadow(blurRadius: 6, color: Colors.black54)],
                       ),
                     ),
                      const SizedBox(height: 6),
                      Text(
                        passed
                            ? 'Niveau suivant débloqué !'                           
                            : 'Trouve 7 bonnes réponses\npour accéder au niveau suivant.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: passed ? 20 : 15,
                          fontWeight: FontWeight.w800,
                          color: passed ? Colors.white : Colors.white70,
                          shadows: const [
                            Shadow(blurRadius: 2, color: Colors.black87, offset: Offset(1, 1)),
                            Shadow(blurRadius: 8, color: Colors.black54),
                          ],
                        ),
                      ),
                   ],
                 ),
               ),
               
               const SizedBox(height: 24),
               
               // Action buttons
               if (!passed) ...[  
                 // Failed: [Rejouer 500⭐]  +  [Retour]
                 Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 40),
                   child: Row(
                     children: [
                        Expanded(
                          child: SizedBox(
                            height: 56,
                            child: BubblyButton(
                              color: Colors.deepOrange,
                              onTap: () {
                                if (widget.onReplay != null) widget.onReplay!();
                              },
                              child: const Text(
                                'REJOUER (500 ⭐)',
                                style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w900),
                              ),
                            ),
                          ),
                        ),
                       const SizedBox(width: 12),
                       Expanded(
                         child: BubblyButton(
                           color: const Color(0xFF0078D4),
                           onTap: () {
                             if (widget.onComplete != null) widget.onComplete!(correctCount, totalStars);
                           },
                           child: const Text('RETOUR', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w900)),
                         ),
                       ),
                     ],
                   ),
                 ),
               ] else ...[  
                 // Passed: single [Retour] button
                 SizedBox(
                   width: 250,
                   child: BubblyButton(
                     color: const Color(0xFF0078D4),
                     onTap: () {
                       if (widget.onComplete != null) widget.onComplete!(correctCount, totalStars);
                     },
                     child: const Text('RETOUR', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
                   ),
                 ),
               ],
               const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  /// Renders answer dots in rows of 5 maximum.
  Widget _buildResultDots() {
    const int perRow = 5;
    const double dotSize = 40.0;
    const double spacing = 10.0;

    final List<Widget> dots = List.generate(_questions.length, (index) {
      final bool isAnswered = index < _results.length;
      final bool isCorrect = isAnswered && _results[index].isCorrect;
      return Container(
        width: dotSize,
        height: dotSize,
        decoration: BoxDecoration(
          color: isAnswered ? (isCorrect ? const Color(0xFF7FBA00) : Colors.redAccent) : Colors.grey.shade300,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Icon(
          isAnswered ? (isCorrect ? Icons.check : Icons.close) : Icons.question_mark,
          color: Colors.white,
          size: 20,
        ),
      );
    });

    // Split into chunks of perRow
    final List<List<Widget>> rows = [];
    for (int i = 0; i < dots.length; i += perRow) {
      rows.add(dots.sublist(i, i + perRow > dots.length ? dots.length : i + perRow));
    }

    return Column(
      children: rows.map((rowDots) => Padding(
        padding: const EdgeInsets.only(bottom: spacing),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: rowDots.map((dot) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: spacing / 2),
            child: dot,
          )).toList(),
        ),
      )).toList(),
    );
  }
} // end _QuizScreenState

class DottedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  DottedBorderPainter({this.color = Colors.grey, this.strokeWidth = 3});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    const dashWidth = 8;
    const dashSpace = 8;
    
    // Top
    double cx = 0;
    while (cx < size.width) {
      canvas.drawLine(Offset(cx, 0), Offset(cx + dashWidth, 0), paint);
      cx += dashWidth + dashSpace;
    }
    // Bottom
    cx = 0;
    while (cx < size.width) {
      canvas.drawLine(Offset(cx, size.height), Offset(cx + dashWidth, size.height), paint);
      cx += dashWidth + dashSpace;
    }
    // Left
    double cy = 0;
    while (cy < size.height) {
      canvas.drawLine(Offset(0, cy), Offset(0, cy + dashWidth), paint);
      cy += dashWidth + dashSpace;
    }
    // Right
    cy = 0;
    while (cy < size.height) {
      canvas.drawLine(Offset(size.width, cy), Offset(size.width, cy + dashWidth), paint);
      cy += dashWidth + dashSpace;
    }
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// Paints an octagonal shape with a white fill and a dashed grey border.
/// Used as the sign "frame" in the quiz screen.
class OctagonSignPainter extends CustomPainter {
  final Color borderColor;
  final Color fillColor;
  final double strokeWidth;

  OctagonSignPainter({
    this.borderColor = const Color(0xFFBDBDBD),
    this.fillColor = Colors.white,
    this.strokeWidth = 2.5,
  });

  Path _octagonPath(Size size) {
    // Cut = 20% of the shorter side for a nice octagon
    final cut = size.shortestSide * 0.2;
    final w = size.width;
    final h = size.height;
    return Path()
      ..moveTo(cut, 0)
      ..lineTo(w - cut, 0)
      ..lineTo(w, cut)
      ..lineTo(w, h - cut)
      ..lineTo(w - cut, h)
      ..lineTo(cut, h)
      ..lineTo(0, h - cut)
      ..lineTo(0, cut)
      ..close();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final path = _octagonPath(size);

    // White fill
    canvas.drawPath(path, Paint()..color = fillColor..style = PaintingStyle.fill);

    // Dashed border
    final borderPaint = Paint()
      ..color = borderColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    const dashLen = 6.0;
    const gapLen = 5.0;
    final metrics = path.computeMetrics();
    for (final m in metrics) {
      double dist = 0;
      bool drawing = true;
      while (dist < m.length) {
        final end = (dist + (drawing ? dashLen : gapLen)).clamp(0.0, m.length);
        if (drawing) {
          canvas.drawPath(m.extractPath(dist, end), borderPaint);
        }
        dist = end;
        drawing = !drawing;
      }
    }
  }

  @override
  bool shouldRepaint(OctagonSignPainter old) =>
      old.borderColor != borderColor || old.fillColor != fillColor;
}


class AnimatedBlinkingBorder extends StatefulWidget {
  final Color color;
  final double thickness;
  const AnimatedBlinkingBorder({super.key, required this.color, this.thickness = 6});
  @override
  State<AnimatedBlinkingBorder> createState() => _AnimatedBlinkingBorderState();
}

class _AnimatedBlinkingBorderState extends State<AnimatedBlinkingBorder> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300))..repeat(reverse: true);
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: widget.color.withOpacity(0.4 + (_controller.value * 0.6)), width: widget.thickness),
          ),
        );
      },
    );
  }
}

class QuizQuestionResult {
  final int questionIndex;
  final bool isCorrect;
  final int starsEarned;
  final int timeRemaining;
  final bool hintUsed;
  QuizQuestionResult({required this.questionIndex, required this.isCorrect, required this.starsEarned, required this.timeRemaining, this.hintUsed = false});
}
