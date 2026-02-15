import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'config/app_config.dart';

/// The core logic to start the app, used by different environment entry points.
void bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Note: For now, we use the same Firebase options for all envs.
  // In a real multi-project setup, each env file would provide its options.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const BLRSApp());
}

// Fallback main for standard run
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
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.traffic_rounded, size: 100, color: Theme.of(context).primaryColor),
              const SizedBox(height: 20),
              Text(
                config.appName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF25022),
                ),
              ),
              const SizedBox(height: 10),
              Text('ENV: ${config.environment.name.toUpperCase()}'),
              const SizedBox(height: 40),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
