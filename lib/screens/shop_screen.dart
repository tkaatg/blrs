import 'package:flutter/material.dart';
import '../models/player_model.dart';
import '../widgets/bubbly_button.dart';

class ShopScreen extends StatelessWidget {
  final Player player;

  const ShopScreen({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF004D40), // Dark teal background typical of game sub-menus
      appBar: AppBar(
        title: const Text('Boutique', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Promo Banner: No-Ads
            _buildPromoCard(),
            const SizedBox(height: 24),
            
            // Star Packages
            _buildShopItem(context, '1000 Étoiles', '1,99 €', Icons.star, Colors.amber),
            _buildShopItem(context, '5000 Étoiles', '8,99 €', Icons.star, Colors.amber, hasBonus: true, bonusDesc: '1 Jour Sans Pub'),
            _buildShopItem(context, '10000 Étoiles', '17,99 €', Icons.star, Colors.amber, hasBonus: true, bonusDesc: '3 Jours Sans Pub'),
            _buildShopItem(context, '50000 Étoiles', '59,99 €', Icons.star, Colors.amber, hasBonus: true, bonusDesc: '14 Jours Sans Pub'),
          ],
        ),
      ),
    );
  }

  Widget _buildPromoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.lightBlue[100],
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white, width: 4),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Supprimer pubs', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 4),
                const Text('Jouez 30 jours sans pubs !', style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                BubblyButton(
                  onTap: () {},
                  color: Colors.blue,
                  child: const Text('1,99 €', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // TV Icon with No-Ads
          Stack(
            alignment: Alignment.center,
            children: [
              const Icon(Icons.tv_rounded, size: 80, color: Colors.orangeAccent),
              const Positioned(
                top: 0,
                right: 0,
                child: Icon(Icons.block, color: Colors.red, size: 30),
              ),
              const Text('ADS\nFREE', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShopItem(BuildContext context, String title, String price, IconData icon, Color color, {bool hasBonus = false, String? bonusDesc}) {
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
          Icon(icon, color: color, size: 40),
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
            onTap: () {},
            color: Colors.cyan[400]!,
            width: 100,
            child: Text(price, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

// Simple Helper for AppBar spacing
extension AppBarSpacer on AppBar {
  static final double height = 56.0;
}
