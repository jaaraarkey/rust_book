class AppConstants {
  // App Information
  static const String appName = 'Smart Notes';
  static const String appVersion = '0.1.0';

  // Storage Keys
  static const String notesBoxKey = 'notes_box';
  static const String foldersBoxKey = 'folders_box';
  static const String settingsBoxKey = 'settings_box';

  // API Endpoints (for future backend integration)
  static const String baseUrl = 'https://api.smartnotes.app';
  static const String notesEndpoint = '/notes';
  static const String foldersEndpoint = '/folders';
  static const String authEndpoint = '/auth';

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;

  // Note Colors
  static const List<String> noteColors = [
    '#FFFFFF', // White
    '#FFE4E1', // Light Pink
    '#E1F5FE', // Light Blue
    '#E8F5E8', // Light Green
    '#FFF3E0', // Light Orange
    '#F3E5F5', // Light Purple
    '#FFECB3', // Light Yellow
    '#F5F5F5', // Light Grey
  ];

  // File Upload
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'gif'];
  static const List<String> allowedDocumentTypes = [
    'pdf',
    'doc',
    'docx',
    'txt'
  ];

  // Search
  static const int searchDelayMs = 300;
  static const int maxSearchResults = 50;

  // Pagination
  static const int defaultPageSize = 20;

  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
}
