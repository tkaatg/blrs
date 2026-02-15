import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'config/app_config.dart';
import 'services/auth_service.dart';
import 'models/player_model.dart';
import 'screens/main_screen.dart';

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

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final player = Provider.of<Player?>(context);
    final authService = Provider.of<AuthService>(context, listen: false);

    // If player is not null, go to main screen
    if (player != null) {
      return MainScreen(player: player);
    }

    // Otherwise, sign in anonymously (Silent login)
    return FutureBuilder(
      future: authService.signInAnonymously(),
      builder: (context, snapshot) {
        return const SplashScreen();
      },
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
