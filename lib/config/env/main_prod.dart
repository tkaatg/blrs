import 'package:flutter/material.dart';
import '../../config/app_config.dart';
import '../../main.dart';

void main() {
  AppConfig.initialize(
    AppConfig(
      environment: EnvironmentType.prod,
      appName: 'Baby Learning Road Signs',
      apiBaseUrl: 'https://api.lldc.com',
      showDebugBanner: false,
    ),
  );
  
  bootstrap();
}
