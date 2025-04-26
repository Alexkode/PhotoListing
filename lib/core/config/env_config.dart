import 'package:flutter/foundation.dart';

enum Environment { dev, staging, prod }

class EnvConfig {
  final String apiBaseUrl;
  final String apiKey;
  final Environment environment;

  static late EnvConfig _instance;

  EnvConfig._({
    required this.apiBaseUrl,
    required this.apiKey,
    required this.environment,
  });

  factory EnvConfig.init({
    required Environment env,
    required String apiKey,
  }) {
    _instance = EnvConfig._(
      apiBaseUrl: _getBaseUrl(env),
      apiKey: apiKey,
      environment: env,
    );
    return _instance;
  }

  static EnvConfig get instance => _instance;

  static String _getBaseUrl(Environment env) {
    switch (env) {
      case Environment.dev:
        return 'http://localhost:3000/api';
      case Environment.staging:
        return 'https://staging-api.photolisting.com/api';
      case Environment.prod:
        return 'https://api.photolisting.com/api';
    }
  }

  static bool get isDevelopment => _instance.environment == Environment.dev;
  static bool get isStaging => _instance.environment == Environment.staging;
  static bool get isProduction => _instance.environment == Environment.prod;

  @visibleForTesting
  static void reset() {
    _instance = EnvConfig._(
      apiBaseUrl: 'http://localhost:3000/api',
      apiKey: 'test_key',
      environment: Environment.dev,
    );
  }
} 