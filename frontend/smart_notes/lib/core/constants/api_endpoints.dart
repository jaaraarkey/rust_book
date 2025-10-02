class ApiEndpoints {
  // Base URLs
  static const String baseUrl = 'https://api.smartnotes.com';
  static const String graphqlEndpoint = '$baseUrl/graphql';

  // Authentication Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String verifyEmail = '/auth/verify-email';

  // User Endpoints
  static const String profile = '/user/profile';
  static const String updateProfile = '/user/profile';
  static const String changePassword = '/user/change-password';
  static const String deleteAccount = '/user/delete-account';

  // Folders Endpoints
  static const String folders = '/folders';
  static const String createFolder = '/folders';
  static const String updateFolder = '/folders';
  static const String deleteFolder = '/folders';
  static const String folderById = '/folders/{id}';

  // Notes Endpoints
  static const String notes = '/notes';
  static const String createNote = '/notes';
  static const String updateNote = '/notes';
  static const String deleteNote = '/notes';
  static const String noteById = '/notes/{id}';
  static const String notesByFolder = '/folders/{folderId}/notes';
  static const String searchNotes = '/notes/search';

  // Dashboard Endpoints
  static const String dashboardStats = '/dashboard/stats';
  static const String recentNotes = '/dashboard/recent-notes';
  static const String recentFolders = '/dashboard/recent-folders';

  // File Upload Endpoints
  static const String uploadFile = '/files/upload';
  static const String deleteFile = '/files/{id}';
  static const String getFile = '/files/{id}';

  // Search Endpoints
  static const String globalSearch = '/search';
  static const String searchSuggestions = '/search/suggestions';

  // Settings Endpoints
  static const String settings = '/settings';
  static const String updateSettings = '/settings';

  // Utility methods
  static String getFolderUrl(String id) => folderById.replaceAll('{id}', id);
  static String getNoteUrl(String id) => noteById.replaceAll('{id}', id);
  static String getNotesByFolderUrl(String folderId) =>
      notesByFolder.replaceAll('{folderId}', folderId);
  static String getFileUrl(String id) => getFile.replaceAll('{id}', id);
  static String getDeleteFileUrl(String id) =>
      deleteFile.replaceAll('{id}', id);
}
