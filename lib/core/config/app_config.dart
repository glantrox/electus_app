import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Centralized application configuration.
/// All values are sourced from the `.env` file at the project root.
class AppConfig {
  AppConfig._();

  /// The base URL for the backend API.
  static String get apiBaseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'http://localhost:3000';

  /// Default avatar URL used when the user has no profile picture.
  static String get defaultAvatarUrl =>
      dotenv.env['DEFAULT_AVATAR_URL'] ?? 'https://i.pravatar.cc/150?img=47';

  /// Device name sent with authentication requests.
  static String get deviceName => dotenv.env['DEVICE_NAME'] ?? 'Flutter Client';
}
