class AppConstants {
  // App Information
  static const String appName = 'Smart Notes';
  static const String appVersion = '1.0.0';

  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 50;
  static const int maxNoteTitleLength = 200;
  static const int maxNoteContentLength = 100000;
  static const int maxFolderNameLength = 100;

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Cache
  static const Duration cacheValidityDuration = Duration(hours: 1);
  static const int maxCacheItems = 100;

  // File Upload
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedFileTypes = [
    'jpg',
    'jpeg',
    'png',
    'gif',
    'pdf',
    'doc',
    'docx',
    'txt'
  ];

  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  // Error Messages
  static const String genericErrorMessage =
      'Something went wrong. Please try again.';
  static const String networkErrorMessage =
      'Please check your internet connection and try again.';
  static const String timeoutErrorMessage =
      'Request timed out. Please try again.';
  static const String unauthorizedErrorMessage =
      'You are not authorized to perform this action.';

  // Success Messages
  static const String loginSuccessMessage = 'Welcome back!';
  static const String registerSuccessMessage = 'Account created successfully!';
  static const String noteCreatedMessage = 'Note created successfully!';
  static const String noteUpdatedMessage = 'Note updated successfully!';
  static const String noteDeletedMessage = 'Note deleted successfully!';
  static const String folderCreatedMessage = 'Folder created successfully!';
  static const String folderDeletedMessage = 'Folder deleted successfully!';
}
