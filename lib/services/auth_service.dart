import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/player_model.dart';
import 'utils/pseudo_generator.dart';

class AuthService {
  FirebaseAuth get _auth => FirebaseAuth.instance;
  FirebaseFirestore get _db => FirebaseFirestore.instance;
  
  // Set to true to bypass Firebase completely and use offline mock data
  static bool useMockMode = true; 

  /// Stream of the current player data
  Stream<Player?> get playerStream {
    if (useMockMode) {
      return Stream.value(Player(
        uid: 'mock_uid',
        pseudo: 'LAPIN1234', 
        stars: 1500,
        points: 0,
        createdAt: DateTime.now(),
        unlockedLevels: [1],
        maxLevelUnlocked: 1,
        statsLevels: {},
        bestPointsByLevel: {},
        avatarId: 'circle',
        musicEnabled: true,
        sfxEnabled: true,
      ));
    }

    return _auth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      
      final doc = await _db.collection('players').doc(user.uid).get();
      if (doc.exists) {
        return Player.fromFirestore(doc);
      } else {
        // This case should theoretically not happen if sign-in logic is correct
        return null;
      }
    });
  }

  Future<String?> signInAnonymously() async {
    if (useMockMode) {
      // Simulate small delay for splash screen visibility
      await Future.delayed(const Duration(milliseconds: 500));
      return null;
    }

    try {
      final credential = await _auth.signInAnonymously();
      final user = credential.user;

      if (user != null) {
        final playerDoc = await _db.collection('players').doc(user.uid).get();
        
        if (!playerDoc.exists) {
          final newPlayer = Player(
            uid: user.uid,
            pseudo: PseudoGenerator.generate(),
            stars: 1500,
            points: 0,
            createdAt: DateTime.now(),
            unlockedLevels: [1],
            maxLevelUnlocked: 1,
            statsLevels: {},
            bestPointsByLevel: {},
            avatarId: 'circle',
            musicEnabled: true,
            sfxEnabled: true,
          );
          
          await _db.collection('players').doc(user.uid).set(newPlayer.toFirestore());
        }
      }
      return null; // Success
    } on FirebaseAuthException catch (e) {
      print('Auth Error: ${e.code} - ${e.message}');
      return e.message ?? e.code;
    } catch (e) {
      print('Generic Auth Error: $e');
      return e.toString();
    }
  }

  /// Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Persist player data to Firestore
  Future<void> updatePlayer(Player player) async {
    if (useMockMode) {
      print('AuthService: Mock Update for ${player.uid}');
      return;
    }
    try {
      await _db.collection('players').doc(player.uid).update(player.toFirestore());
    } catch (e) {
      print('AuthService: Error updating player: $e');
    }
  }
}
