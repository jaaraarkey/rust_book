import 'package:flutter/material.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/folders/presentation/pages/folders_page.dart';
import '../../features/folders/presentation/pages/folder_detail_page.dart';
import '../../features/notes/presentation/pages/notes_list_page.dart';
import '../../features/notes/presentation/pages/note_editor_page.dart';
import '../../features/notes/presentation/pages/search_notes_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/settings/presentation/pages/profile_page.dart';
import '../../widgets/auth_wrapper.dart';

class RouteConfig {
  // Route names
  static const String splash = '/';
  static const String authWrapper = '/auth-wrapper';
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String folders = '/folders';
  static const String folderDetail = '/folder-detail';
  static const String notesList = '/notes';
  static const String noteEditor = '/note-editor';
  static const String searchNotes = '/search-notes';
  static const String settings = '/settings';
  static const String profile = '/profile';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const AuthWrapper());

      case authWrapper:
        return MaterialPageRoute(builder: (_) => const AuthWrapper());

      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case register:
        return MaterialPageRoute(builder: (_) => const RegisterPage());

      case dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardPage());

      case folders:
        return MaterialPageRoute(builder: (_) => const FoldersPage());

      case folderDetail:
        final args = settings.arguments as Map<String, dynamic>?;
        final folderId = args?['folderId'] as String?;
        return MaterialPageRoute(
          builder: (_) => FolderDetailPage(folderId: folderId ?? ''),
        );

      case notesList:
        final args = settings.arguments as Map<String, dynamic>?;
        final folderId = args?['folderId'] as String?;
        return MaterialPageRoute(
          builder: (_) => NotesListPage(folderId: folderId),
        );

      case noteEditor:
        final args = settings.arguments as Map<String, dynamic>?;
        final noteId = args?['noteId'] as String?;
        final folderId = args?['folderId'] as String?;
        return MaterialPageRoute(
          builder: (_) => NoteEditorPage(
            noteId: noteId,
            folderId: folderId,
          ),
        );

      case searchNotes:
        return MaterialPageRoute(builder: (_) => const SearchNotesPage());

      case RouteConfig.settings:
        return MaterialPageRoute(builder: (_) => const SettingsPage());

      case profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Route not found: ${settings.name}'),
            ),
          ),
        );
    }
  }
}
