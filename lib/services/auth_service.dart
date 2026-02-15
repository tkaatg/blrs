import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/player_model.dart';
import 'utils/pseudo_generator.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Stream of the current player data
  Stream<Player?> get playerStream {
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

  /// Sign in anonymously and create a profile if it doesn't exist
  Future<User?> signInAnonymously() async {
    try {
      final credential = await _auth.signInAnonymously();
      final user = credential.user;

      if (user != null) {
        final playerDoc = await _db.collection('players').doc(user.uid).get();
        
        if (!playerDoc.exists) {
          // Create initial profile
          final newPlayer = Player(
            uid: user.uid,
            pseudo: PseudoGenerator.generate(),
            stars: 1500, // Initial balance from PRD
            points: 0,
            createdAt: DateTime.now(),
          );
          
          await _db.collection('players').doc(user.uid).set(newPlayer.toFirestore());
        }
      }
      return user;
    } catch (e) {
      print('Auth Error: $e');
      return null;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
