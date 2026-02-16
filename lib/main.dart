import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'config/app_config.dart';
import 'services/auth_service.dart';
import 'models/player_model.dart';
import 'screens/main_navigation_screen.dart'; // Changed from board_game_screen.dart

void bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        StreamProvider<Player?>(
          create: (context) => context.read<AuthService>().playerStream,
          initialData: null,
        ),
      ],
      child: const BLRSApp(),
    ),
  );
}

void main() {
  AppConfig.initialize(
    AppConfig(
      environment: EnvironmentType.dev,
      appName: 'BLRS (Manual)',
      apiBaseUrl: 'https://dev.api.lldc.com',
      showDebugBanner: true,
    ),
  );
  bootstrap();
}

class BLRSApp extends StatelessWidget {
  const BLRSApp({super.key});

  @override
  Widget build(BuildContext context) {
    final config = AppConfig.instance;
    
    return MaterialApp(
      debugShowCheckedModeBanner: config.showDebugBanner,
      title: config.appName,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFF25022),
          primary: const Color(0xFFF25022),
          secondary: const Color(0xFF7FBA00),
          tertiary: const Color(0xFF00A4EF),
          surface: const Color(0xFFFFB900),
        ),
      ),
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  String? _error;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _attemptSignIn();
  }

  Future<void> _attemptSignIn() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final error = await authService.signInAnonymously();
    
    if (mounted) {
      setState(() {
        _error = error;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final player = Provider.of<Player?>(context);

    if (player != null) {
      return MainNavigationScreen(player: player);
    }

    if (_error != null) {
      // Fallback for visual testing if Firestore is persistent offline
      if (_error!.contains('offline') || _error!.contains('unavailable')) {
        return Scaffold(
          body: Stack(
            children: [
              MainNavigationScreen(
                player: Player(
                  uid: 'debug',
                  pseudo: 'DEMO_PLAYER',
                  stars: 1500,
                  points: 0,
                  createdAt: DateTime.now(),
                  unlockedLevels: [1],
                  statsLevels: {},
                ),
              ),
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.black54,
                  child: const Text(
                    'MODE DÉMO (Firestore Offline)',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        );
      }
      
      return ErrorScreen(
        message: _error!,
        onRetry: _attemptSignIn,
      );
    }

    return const SplashScreen();
  }
}

class ErrorScreen extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorScreen({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 80),
              const SizedBox(height: 20),
              const Text(
                'Oups ! Un petit problème...',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Réessayer'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF25022),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.traffic_rounded, size: 100, color: Theme.of(context).primaryColor),
            const SizedBox(height: 20),
            const Text(
              'Baby Learning Road Signs',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFF25022),
              ),
            ),
            const SizedBox(height: 10),
            const Text('Chargement du profil...'),
            const SizedBox(height: 40),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
