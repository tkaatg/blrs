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

  Future<String?> signInAnonymously() async {
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
}
