import 'package:flutter/material.dart';
import '../models/player_model.dart';
import '../services/leaderboard_service.dart';
import '../widgets/bubbly_title.dart';

class LeaderboardScreen extends StatelessWidget {
  final Player player;

  const LeaderboardScreen({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    final entries = LeaderboardService.getLeaderboardView(player);

    return Container(
      color: const Color(0xFF00382B),
      child: Column(
        children: [
          const SizedBox(height: 110),
          const BubblyTitle(title: 'Classement'),
          const SizedBox(height: 30),
          
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];
                
                if (entry.uid == 'sep') {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                      child: Text('• • •', style: TextStyle(color: Colors.white54, fontSize: 24, fontWeight: FontWeight.bold)),
                    ),
                  );
                }

                bool isMe = entry.uid == player.uid;
                
                return _buildLeaderboardRow(entry, isMe);
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildLeaderboardRow(LeaderboardEntry entry, bool isMe) {
    Color rankColor = Colors.white70;
    Widget? medal;

    if (entry.rank == 1) {
      rankColor = Colors.amber;
      medal = const Icon(Icons.emoji_events, color: Colors.amber, size: 24);
    } else if (entry.rank == 2) {
      rankColor = const Color(0xFFC0C0C0); // Silver
      medal = const Icon(Icons.emoji_events, color: Color(0xFFC0C0C0), size: 22);
    } else if (entry.rank == 3) {
      rankColor = const Color(0xFFCD7F32); // Bronze
      medal = const Icon(Icons.emoji_events, color: Color(0xFFCD7F32), size: 20);
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isMe ? Colors.white.withOpacity(0.15) : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isMe ? Colors.amber.withOpacity(0.5) : Colors.white10,
          width: isMe ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          // Rank
          SizedBox(
            width: 45,
            child: medal ?? Text(
              '${entry.rank}',
              style: TextStyle(color: rankColor, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          
          // Avatar
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white24,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white30),
            ),
            child: ClipOval(
              child: entry.avatarId.isEmpty 
                  ? const Icon(Icons.person, color: Colors.white)
                  : Image.asset(
                      'assets/images/avatars/avatar_${_getAvatarFileName(entry.avatarId)}.png',
                      fit: BoxFit.contain,
                      errorBuilder: (c, e, s) => const Icon(Icons.person, color: Colors.white),
                    ),
            ),
          ),
          
          const SizedBox(width: 15),
          
          // Pseudo
          Expanded(
            child: Text(
              isMe ? '${entry.pseudo} (TOI)' : entry.pseudo,
              style: TextStyle(
                color: isMe ? Colors.amber : Colors.white,
                fontSize: 16,
                fontWeight: isMe ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          
          // Points
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${entry.points}',
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 1),
              ),
              const Text(
                'POINTS',
                style: TextStyle(color: Colors.white54, fontSize: 9, fontWeight: FontWeight.bold),
              ),
            ],
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
}
