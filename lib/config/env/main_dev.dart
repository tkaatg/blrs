import 'package:flutter/material.dart';
import '../../config/app_config.dart';
import '../../main.dart';

void main() {
  AppConfig.initialize(
    AppConfig(
      environment: EnvironmentType.dev,
      appName: '[DEV] BLRS',
      apiBaseUrl: 'https://dev.api.lldc.com',
      showDebugBanner: true,
    ),
  );
  
  bootstrap();
}
