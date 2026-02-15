enum EnvironmentType { dev, staging, prod }

class AppConfig {
  final EnvironmentType environment;
  final String appName;
  final String apiBaseUrl;
  final bool showDebugBanner;

  AppConfig({
    required this.environment,
    required this.appName,
    required this.apiBaseUrl,
    this.showDebugBanner = false,
  });

  static late AppConfig _instance;
  static AppConfig get instance => _instance;

  static void initialize(AppConfig config) {
    _instance = config;
  }
}
