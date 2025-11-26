import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  const Environment._();

  static Future<void> load() async {
    try {
      const String env = String.fromEnvironment('ENV', defaultValue: 'dev');

      String envFile;
      switch (env) {
        case 'stag':
          envFile = 'env/.env.stag';
          break;
        case 'prod':
          envFile = 'env/.env.prod';
          break;
        default:
          envFile = 'env/.env.dev';
          break;
      }

      await dotenv.load(fileName: envFile);
    } catch (e) {
      // If env file doesn't exist or can't be loaded, continue without it
      // This allows the app to run even if env files are missing
      debugPrint('Warning: Could not load environment file: $e');
    }
  }
}
