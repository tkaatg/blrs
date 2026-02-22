import 'package:flutter/material.dart';
import '../models/level_model.dart';
import '../models/player_model.dart';
import '../widgets/level_node.dart';
import 'quiz_screen.dart';

class BoardGameScreen extends StatefulWidget {
  final Player player;
  final Function(int)? onLevelSelected;
  final VoidCallback? onShopRequested;

  const BoardGameScreen({
    super.key,
    required this.player,
    this.onLevelSelected,
    this.onShopRequested,
  });

  @override
  State<BoardGameScreen> createState() => BoardGameScreenState();
}

class BoardGameScreenState extends State<BoardGameScreen> {
  // Mapping coordinates used for levels
  final List<Map<String, double>> _levelCoords = [
    {'left': 0.605, 'top': 0.930}, // L1
    {'left': 0.770, 'top': 0.835}, // L2
    {'left': 0.435, 'top': 0.790}, // L3
    {'left': 0.220, 'top': 0.675}, // L4
    {'left': 0.585, 'top': 0.620}, // L5
    {'left': 0.775, 'top': 0.505}, // L6
    {'left': 0.485, 'top': 0.425}, // L7
    {'left': 0.245, 'top': 0.335}, // L8
    {'left': 0.725, 'top': 0.255}, // L9
    {'left': 0.500, 'top': 0.045}, // L10
  ];

  void _onLevelTap(LevelStatus level, double boardHeight) {
    if (level.state == LevelState.locked) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Niveau verrouillé. Débloque d\'abord le niveau ${widget.player.maxLevelUnlocked}'))
      );
      return;
    }

    int levelId = level.id;
    bool isFree = widget.player.statsLevels['level_$levelId'] == 10;

    if (!isFree && widget.player.stars < 500) {
      _showNotEnoughStarsDialog();
      return;
    }

    _showStartLevelDialog(levelId, isFree, boardHeight);
  }

  void _showStartLevelDialog(int levelId, bool isFree, double boardHeight) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      barrierDismissible: true, // Tap outside to cancel
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 32),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF003828), Color(0xFF005C40), Color(0xFF004D40)],
              ),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.amber.withOpacity(0.5), width: 2),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.6), blurRadius: 30, spreadRadius: 4),
                BoxShadow(color: Colors.amber.withOpacity(0.15), blurRadius: 20),
              ],
            ),
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title – BubblyTitle style (amber/yellow, bold, shadow)
                Text(
                  'NIVEAU $levelId',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: Colors.amber.shade300,
                    letterSpacing: 2,
                    shadows: const [
                      Shadow(blurRadius: 2, color: Colors.black87, offset: Offset(2, 2)),
                      Shadow(blurRadius: 12, color: Colors.black54),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Cost row
                if (!isFree)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Coût : ', style: TextStyle(color: Colors.white70, fontSize: 16)),
                      const Text('500', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                      const SizedBox(width: 4),
                      const Icon(Icons.star, color: Colors.amber, size: 22),
                    ],
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green.shade800,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text('✅ Gratuit – Mode entraînement',
                      style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
                  ),
                const SizedBox(height: 24),
                // Single launch button (full width)
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    if (!isFree) {
                      setState(() => widget.player.stars -= 500);
                    }
                    if (widget.onLevelSelected != null) widget.onLevelSelected!(levelId);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 54,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.green.shade400, Colors.green.shade700],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: Colors.green.withOpacity(0.5), blurRadius: 12, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.play_arrow_rounded, color: Colors.white, size: 28),
                        SizedBox(width: 6),
                        Text(
                          "C'EST PARTI !",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<LevelStatus> levels = List.generate(10, (index) {
      int levelId = index + 1;
      LevelState state = LevelState.locked;
      int score = 0;

      if (widget.player.unlockedLevels.contains(levelId)) {
        state = widget.player.statsLevels.containsKey('level_$levelId')
            ? LevelState.completed
            : LevelState.available;
        score = widget.player.statsLevels['level_$levelId'] ?? 0;
      }

      return LevelStatus(
        id: levelId,
        state: state,
        score: score,
        isCurrent: levelId == widget.player.maxLevelUnlocked,
      );
    });

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double screenWidth = constraints.maxWidth;
          final double boardWidth = screenWidth > 600 ? 600 : screenWidth;
          final double boardHeight = boardWidth * 4.0;


          return Stack(
            children: [
              Positioned.fill(
                child: Container(color: const Color(0xFF8BC34A)),
              ),
              Center(
                child: SizedBox(
                  width: boardWidth,
                  child: SingleChildScrollView(
                    reverse: true,
                    child: Container(
                      height: boardHeight,
                      width: boardWidth,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned.fill(
                            child: Column(
                              children: [
                                Image.asset('assets/images/board_background.png', width: boardWidth, fit: BoxFit.fitWidth),
                                Image.asset('assets/images/board_background.png', width: boardWidth, fit: BoxFit.fitWidth),
                                Image.asset('assets/images/board_background.png', width: boardWidth, fit: BoxFit.fitWidth),
                                Image.asset('assets/images/board_background.png', width: boardWidth, fit: BoxFit.fitWidth),
                              ],
                            ),
                          ),
                          
                          // Draw levels
                          ...List.generate(10, (idx) {
                            final coord = _levelCoords[idx];
                            return _buildLevelPositioned(
                              context, 
                              boardWidth, 
                              boardHeight, 
                              levels[idx], 
                              left: coord['left']!, 
                              top: coord['top']!
                            );
                          }),

                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildLevelPositioned(BuildContext context, double boardWidth, double boardHeight, LevelStatus level, {required double left, required double top}) {
    return Positioned(
      left: boardWidth * left - 45,
      top: boardHeight * top,
      child: LevelNode(
        level: level,
        onTap: () {
          _onLevelTap(level, boardHeight);
        },
      ),
    );
  }

  void _showNotEnoughStarsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: const Color(0xFF004D40),
        title: const Text('Oups !', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.star, color: Colors.amber, size: 60),
            SizedBox(height: 16),
            Text(
              'Il te faut 500 étoiles pour commencer un quiz !',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              minimumSize: const Size(200, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
            ),
            onPressed: () {
              Navigator.pop(context);
              if (widget.onShopRequested != null) {
                widget.onShopRequested!();
              }
            },
            child: const Text('Gagner des étoiles', style: TextStyle(color: Color(0xFF004D40), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void playLastAvailableLevel() {
    int levelId = widget.player.maxLevelUnlocked;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double boardWidth = screenWidth > 600 ? 600 : screenWidth;
    final double boardHeight = boardWidth * 4.0; 
    
    // Find the current level object to check its state
    final level = LevelStatus(
      id: levelId,
      state: widget.player.unlockedLevels.contains(levelId) ? LevelState.available : LevelState.locked,
    );
    _onLevelTap(level, boardHeight);
  }
}
