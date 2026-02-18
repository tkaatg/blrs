import 'package:flutter/material.dart';
import '../models/player_model.dart';
import 'board_game_screen.dart';
import 'shop_screen.dart';
import 'quiz_screen.dart';
import 'settings_screen.dart';
import 'leaderboard_screen.dart';
import '../widgets/bubbly_title.dart';

class MainNavigationScreen extends StatefulWidget {
  final Player player;

  const MainNavigationScreen({super.key, required this.player});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 1; // Default to Home/Accueil (Index 1)
  final GlobalKey<BoardGameScreenState> _boardGameKey = GlobalKey<BoardGameScreenState>();
  int? _activeQuizLevelId;
  bool _quizIsFree = false;

  void _onItemTapped(int index) {
    if (_activeQuizLevelId != null) {
      // Show confirmation even if clicking the current index (1) during quiz
      _showCancelQuizDialog(index);
      return; 
    }
    _doSwitchTab(index);
  }

  void _doSwitchTab(int index) {
    if (index == 2) {
      // "Jouer" button logic: highlights map/accueil and triggers level
      setState(() {
        _selectedIndex = 1;
        _activeQuizLevelId = null; 
      });
      Future.delayed(const Duration(milliseconds: 200), () {
        final boardState = _boardGameKey.currentState;
        if (boardState != null) {
          boardState.playLastAvailableLevel();
        }
      });
      return;
    }
    setState(() {
      _selectedIndex = index;
      _activeQuizLevelId = null;
    });
  }

  void _showCancelQuizDialog(int nextIndex) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF004D40),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Quitter la partie ?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: const Text(
          'Si tu quittes maintenant, ta progression sera perdue et les 500 étoiles ne seront pas remboursées.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Rester', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              Navigator.pop(context);
              _doSwitchTab(nextIndex);
            },
            child: const Text('Quitter', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void startQuiz(int levelId) {
    bool isFree = widget.player.statsLevels['level_$levelId'] == 10;
    setState(() {
      _activeQuizLevelId = levelId;
      _quizIsFree = isFree;
    });
  }

  void _onQuizComplete(int levelId, int score, int starsGained) {
    setState(() {
      _activeQuizLevelId = null;
      widget.player.stars += starsGained;

      // 1. Persist correct answers count if better (For Visual UI)
      int oldCorrectCount = widget.player.statsLevels['level_$levelId'] ?? 0;
      if (score > oldCorrectCount) {
        widget.player.statsLevels['level_$levelId'] = score;
      }

      // 2. Persist speed points if better (For Leaderboard)
      if (!_quizIsFree) {
        int currentBestPoints = widget.player.bestPointsByLevel['level_$levelId'] ?? 0;
        if (starsGained > currentBestPoints) {
          widget.player.bestPointsByLevel['level_$levelId'] = starsGained;
          widget.player.updatePointsFromBestScores();
        }
      }

      // Unlock next level if score >= 5 (passing grade)
      if (score >= 5) {
        int nextLevel = levelId + 1;
        if (nextLevel <= 10) {
          if (!widget.player.unlockedLevels.contains(nextLevel)) {
            widget.player.unlockedLevels.add(nextLevel);
          }
          // Increment maxLevelUnlocked if we just beat the highest unlocked level
          if (levelId == widget.player.maxLevelUnlocked) {
            widget.player.maxLevelUnlocked = nextLevel;
          }
        }
      }
      _selectedIndex = 1; // Return to map
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      ShopScreen(
        player: widget.player, 
        onPurchaseComplete: (stars) {
          setState(() {
            widget.player.stars += stars;
          });
        }
      ),
      BoardGameScreen(
        key: _boardGameKey, 
        player: widget.player,
        onLevelSelected: (id) => startQuiz(id),
        onShopRequested: () => _doSwitchTab(0),
      ),
      const SizedBox.shrink(),
      LeaderboardScreen(player: widget.player),
      SettingsScreen(
        player: widget.player,
        onUpdate: () => setState(() {}),
      ),
    ];

    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: _selectedIndex,
            children: screens,
          ),
          
          if (_activeQuizLevelId != null)
            QuizScreen(
              player: widget.player,
              levelId: _activeQuizLevelId!,
              isFree: _quizIsFree,
              onComplete: (score, stars) => _onQuizComplete(_activeQuizLevelId!, score, stars),
            ),

          // TOP RESOURCE BAR
          Positioned(
            top: 40,
            left: 10,
            right: 10,
            child: _buildTopResourceBar(),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildTopResourceBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Profile - Left aligned, natural width
          GestureDetector(
            onTap: () => _onItemTapped(4), // Jump to settings
            child: _buildTopChip(
              null, 
              widget.player.pseudo, 
              Colors.white,
              imagePath: 'assets/images/avatars/avatar_${_getAvatarFileName(widget.player.avatarId)}.png',
            ),
          ),
          
          // Stars + Shop shortcut - Right aligned, natural width
          _buildTopChip(
            Icons.star, 
            '${widget.player.stars}', 
            Colors.amber,
            onAdd: () => _onItemTapped(0), // Jump to shop
            isRightAligned: true,
          ),
        ],
      ),
    );
  }

  String _getAvatarFileName(String id) {
    switch (id) {
      case 'square': return 'carre';
      case 'triangle': return 'triangle';
      case 'diamond': return 'losange';
      case 'circle': return 'rond';
      default: return 'rond';
    }
  }

  Widget _buildTopChip(IconData? icon, String label, Color iconColor, {VoidCallback? onAdd, String? imagePath, bool isRightAligned = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      constraints: const BoxConstraints(maxWidth: 160), // Limit width to fit 5+4 chars
      decoration: BoxDecoration(
        color: const Color(0xFF00382B).withOpacity(0.8),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: isRightAligned ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (imagePath != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.asset(imagePath, width: 24, height: 24, fit: BoxFit.contain),
            )
          else if (icon != null)
            Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          if (onAdd != null) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onAdd,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                child: const Icon(Icons.add, color: Colors.white, size: 16),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF00695C), 
        border: const Border(top: BorderSide(color: Colors.white24, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -2),
          )
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.shopping_cart_rounded, 'Boutique', Colors.pinkAccent),
              _buildNavItem(1, Icons.home_rounded, 'Accueil', Colors.orangeAccent),
              _buildNavItem(2, Icons.play_circle_filled_rounded, 'Jouer', Colors.redAccent),
              _buildNavItem(3, Icons.leaderboard_rounded, 'Classement', Colors.lightBlueAccent),
              _buildNavItem(4, Icons.settings_rounded, 'Réglages', Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, Color activeColor) {
    bool isQuizActive = _activeQuizLevelId != null;
    bool isSelected = _selectedIndex == index;
    bool isJouer = index == 2;
    
    // Standardize the container for all items
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 75, // Same width for all
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                // Same shape and sizing logic for everyone
                color: isJouer 
                    ? (isQuizActive ? activeColor : Colors.transparent)
                    : (isSelected && !isQuizActive ? Colors.white.withOpacity(0.15) : Colors.transparent),
                borderRadius: BorderRadius.circular(12), // Reduced rounding
                border: Border.all(
                  color: (isSelected || (isJouer && isQuizActive)) ? Colors.white30 : Colors.transparent, 
                  width: 1
                ),
              ),
              child: Icon(
                icon, 
                color: isJouer 
                    ? (isQuizActive ? Colors.white : Colors.white.withOpacity(0.5)) 
                    : (isSelected && !isQuizActive ? activeColor : Colors.white60), 
                size: 28
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: (isSelected || (isJouer && isQuizActive)) ? Colors.white : Colors.white60,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderScreen(String title, IconData icon, Color color) {
    return Container(
      color: const Color(0xFF00382B),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 120),
          BubblyTitle(title: title),
          const SizedBox(height: 60),
          Icon(icon, size: 120, color: color.withOpacity(0.3)),
          const SizedBox(height: 30),
          const Text(
            'Bientôt disponible !',
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text('En cours de développement...', style: TextStyle(color: Colors.white60)),
        ],
      ),
    );
  }
}
