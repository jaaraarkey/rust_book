class AppConfig {
  static const String appName = 'Smart Notes';
  static const String appVersion = '1.0.0';
  static const String appDescription =
      'A smart note-taking app with folders and organization';

  // API Configuration
  static const String baseUrl = 'https://api.smartnotes.com';
  static const String graphqlEndpoint = '$baseUrl/graphql';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Cache Configuration
  static const Duration cacheValidityDuration = Duration(minutes: 30);
  static const int maxCacheSize = 50; // Number of items

  // Features Flags
  static const bool enableOfflineMode = true;
  static const bool enableDarkMode = true;
  static const bool enableNotifications = true;
  static const bool enableBiometricAuth = true;
}
