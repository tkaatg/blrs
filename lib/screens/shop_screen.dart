import 'package:flutter/material.dart';
import '../models/player_model.dart';
import '../widgets/bubbly_button.dart';
import '../widgets/bubbly_title.dart';
import 'dart:async';

class ShopScreen extends StatefulWidget {
  final Player player;
  final Function(int)? onPurchaseComplete;

  const ShopScreen({super.key, required this.player, this.onPurchaseComplete});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  bool _showingAd = false;
  String? _adMessage;

  void _simulateAd(String message, int starsToGain) {
    setState(() {
      _showingAd = true;
      _adMessage = message;
    });

    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showingAd = false;
        });
        if (widget.onPurchaseComplete != null) {
          widget.onPurchaseComplete!(starsToGain);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Achat réussi : + $starsToGain étoiles !'),
            backgroundColor: Colors.green,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00382B), // Harmonisé avec Settings
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: Column(
              children: [
                const SizedBox(height: 110),
                const BubblyTitle(title: 'Boutique'),
                const SizedBox(height: 30),
                
                // Promo Banner: No-Ads
                _buildPromoCard(),
                const SizedBox(height: 24),

                // Free Stars via Ad
                _buildFreeStarsCard(context),
                const SizedBox(height: 16),
                
                // Star Packages
                _buildShopItem(context, '1000 Étoiles', '1,99 €', 1000),
                _buildShopItem(context, '3000 Étoiles', '4,99 €', 3000),
                _buildShopItem(context, '5000 Étoiles', '6,99 €', 5000),
                _buildShopItem(context, '10000 Étoiles', '11,99 €', 10000),
                
                const SizedBox(height: 40),
              ],
            ),
          ),

          // AD SIMULATION OVERLAY
          if (_showingAd)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.9),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(color: Colors.amber),
                      const SizedBox(height: 20),
                      Text(
                        _adMessage ?? 'CHARGEMENT DE LA PUBLICITÉ...',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        '(Simulation pour la démo - 2 secondes)',
                        style: TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPromoCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          // Icône PUB barrée
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(
                  child: Text('PUB', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 1)),
                ),
              ),
              // Barre diagonale rouge
              CustomPaint(
                size: const Size(60, 60),
                painter: _StrikethroughPainter(),
              ),
            ],
          ),
          const SizedBox(width: 18),
          // Titre seul
          const Expanded(
            child: Text(
              'Joue 1 mois sans pub !',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 17,
              ),
            ),
          ),
          // Prix à droite
          BubblyButton(
            onTap: () => _simulateAd('OFFRE SANS PUB ACTIVÉE !', 0),
            color: Colors.amber,
            width: 80,
            child: const Text('2,99€', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 15)),
          ),
        ],
      ),
    );
  }

  Widget _buildFreeStarsCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.deepPurple[100],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Row(
        children: [
          const Icon(Icons.play_circle_fill_rounded, color: Colors.deepPurple, size: 40),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('500 Étoiles gratuites', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text('Regarde une publicité', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
          BubblyButton(
            onTap: () => _simulateAd('CHARGEMENT DE LA VIDÉO...', 500),
            color: Colors.deepPurple,
            width: 100,
            child: const Text('VOIR', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildShopItem(BuildContext context, String title, String price, int stars, {bool hasBonus = false, String? bonusDesc}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          const Icon(Icons.star, color: Colors.amber, size: 40),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                if (hasBonus)
                  Text('+ $bonusDesc', style: const TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          BubblyButton(
            onTap: () => _simulateAd('FINALISATION DE L\'ACHAT...', stars),
            color: Colors.cyan[400]!,
            width: 100,
            child: Text(price, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

/// Draws a red diagonal strikethrough line (like a "no" symbol without the circle)
class _StrikethroughPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    // Top-right to bottom-left diagonal (classic "barré" style)
    canvas.drawLine(
      Offset(size.width * 0.75, size.height * 0.1),
      Offset(size.width * 0.1, size.height * 0.85),
      paint,
    );
  }

  @override
  bool shouldRepaint(_StrikethroughPainter oldDelegate) => false;
}
