import 'package:flutter/material.dart';
import '../models/player_model.dart';
import '../services/auth_service.dart';

class MainScreen extends StatelessWidget {
  final Player player;

  const MainScreen({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BLRS - Plateau de Jeu'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => AuthService().signOut(),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Bienvenue, ${player.pseudo} !',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star, color: Colors.amber),
                const SizedBox(width: 8),
                Text('${player.stars} Étoiles', style: const TextStyle(fontSize: 18)),
              ],
            ),
            const SizedBox(height: 40),
            const Text('Plateau de jeu en cours de construction...'),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
