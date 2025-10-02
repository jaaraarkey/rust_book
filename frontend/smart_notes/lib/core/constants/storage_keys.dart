class StorageKeys {
  // Authentication
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String userId = 'user_id';
  static const String userEmail = 'user_email';
  static const String userName = 'user_name';
  static const String isLoggedIn = 'is_logged_in';
  static const String biometricEnabled = 'biometric_enabled';

  // User Preferences
  static const String themeMode = 'theme_mode';
  static const String language = 'language';
  static const String notificationEnabled = 'notification_enabled';
  static const String autoSaveEnabled = 'auto_save_enabled';
  static const String offlineModeEnabled = 'offline_mode_enabled';

  // App Settings
  static const String firstTimeUser = 'first_time_user';
  static const String appVersion = 'app_version';
  static const String lastSyncTime = 'last_sync_time';
  static const String defaultFolder = 'default_folder';
  static const String noteDisplayMode = 'note_display_mode'; // list, grid
  static const String sortPreference =
      'sort_preference'; // date, name, modified

  // Cache Keys
  static const String cachedFolders = 'cached_folders';
  static const String cachedNotes = 'cached_notes';
  static const String cachedDashboardStats = 'cached_dashboard_stats';
  static const String cachedUserProfile = 'cached_user_profile';

  // Editor Settings
  static const String editorFontSize = 'editor_font_size';
  static const String editorFontFamily = 'editor_font_family';
  static const String editorTheme = 'editor_theme';
  static const String markdownPreviewEnabled = 'markdown_preview_enabled';
  static const String wordWrapEnabled = 'word_wrap_enabled';

  // Search History
  static const String searchHistory = 'search_history';
  static const String maxSearchHistoryItems = 'max_search_history_items';

  // Backup & Sync
  static const String lastBackupTime = 'last_backup_time';
  static const String autoBackupEnabled = 'auto_backup_enabled';
  static const String backupFrequency = 'backup_frequency';

  // Security
  static const String appLockEnabled = 'app_lock_enabled';
  static const String autoLockTimeout = 'auto_lock_timeout';
  static const String failedLoginAttempts = 'failed_login_attempts';
  static const String lastFailedLoginTime = 'last_failed_login_time';

  // Analytics & Debug
  static const String analyticsEnabled = 'analytics_enabled';
  static const String crashReportingEnabled = 'crash_reporting_enabled';
  static const String debugModeEnabled = 'debug_mode_enabled';
}
