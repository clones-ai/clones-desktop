import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get env => dotenv.env['ENV'] ?? 'dev';
  static String get privacyPolicyUrl => dotenv.env['PRIVACY_POLICY_URL'] ?? '';
  static String get baseScanBaseUrl => dotenv.env['BASESCAN_BASE_URL'] ?? '';
  static String get apiWebsiteUrl => dotenv.env['API_WEBSITE_URL'] ?? '';
  static String get apiBackendUrl => dotenv.env['API_BACKEND_URL'] ?? '';
  static String get subgraphUrl => dotenv.env['SUBGRAPH_URL'] ?? '';
}
