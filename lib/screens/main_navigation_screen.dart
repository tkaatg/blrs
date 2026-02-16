import 'package:flutter/material.dart';
import '../models/player_model.dart';
import 'board_game_screen.dart';
import 'shop_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final Player player;

  const MainNavigationScreen({super.key, required this.player});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 1; // Default to Home/Accueil (Index 1)

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      ShopScreen(player: widget.player),
      BoardGameScreen(player: widget.player),
      _buildPlaceholderScreen('Ami·es & Classement', Icons.people_rounded, Colors.orange),
      _buildPlaceholderScreen('Paramètres', Icons.settings_rounded, Colors.blueGrey),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: _selectedIndex,
            children: _screens,
          ),
          
          // TOP RESOURCE BAR (Persistent overlay for stars)
          if (_selectedIndex != 0) // Hide on shop screen if shop has its own
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Profile
        _buildTopChip(Icons.person, widget.player.pseudo, Colors.white),
        
        // Stars + Shop shortcut
        _buildTopChip(
          Icons.star, 
          '${widget.player.stars}', 
          Colors.amber,
          onAdd: () => _onItemTapped(0), // Jump to shop
        ),
      ],
    );
  }

  Widget _buildTopChip(IconData icon, String label, Color iconColor, {VoidCallback? onAdd}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF00382B).withOpacity(0.8),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
        color: const Color(0xFF00695C), // Dark teal base
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
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.store_rounded, 'Boutique', Colors.pinkAccent),
              _buildNavItem(1, Icons.map_rounded, 'Accueil', Colors.orangeAccent),
              _buildNavItem(2, Icons.people_alt_rounded, 'Ami·es', Colors.lightBlueAccent),
              _buildNavItem(3, Icons.settings_rounded, 'Réglages', Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, Color activeColor) {
    bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: isSelected 
          ? BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white30, width: 1),
            )
          : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon, 
              color: isSelected ? activeColor : Colors.white60, 
              size: isSelected ? 32 : 28
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white60,
                fontSize: 11,
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
      color: Colors.teal[900],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 100, color: color.withOpacity(0.5)),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            const Text('En cours de développement...', style: TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}
