import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Core
import 'core/auth/auth_service.dart';
import 'core/network/network_info.dart';
import 'core/storage/local_storage.dart';

// Features - Auth
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/register_usecase.dart';
import 'features/auth/domain/usecases/logout_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

// Features - Dashboard
import 'features/dashboard/domain/usecases/get_dashboard_stats_usecase.dart';
import 'features/dashboard/presentation/bloc/dashboard_bloc.dart';

// Features - Notes
import 'features/notes/data/datasources/notes_data_source.dart';
import 'features/notes/data/datasources/notes_local_data_source.dart';
import 'features/notes/data/datasources/notes_remote_data_source.dart';
import 'features/notes/data/repositories/notes_repository_impl.dart';
import 'features/notes/domain/repositories/notes_repository.dart';
import 'features/notes/domain/usecases/get_all_notes.dart';
import 'features/notes/domain/usecases/get_note_by_id.dart';
import 'features/notes/domain/usecases/create_note.dart';
import 'features/notes/domain/usecases/update_note.dart';
import 'features/notes/domain/usecases/delete_note.dart';
import 'features/notes/presentation/bloc/notes_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Auth
  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      loginUsecase: sl(),
      registerUsecase: sl(),
      logoutUsecase: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginUsecase(sl()));
  sl.registerLazySingleton(() => RegisterUsecase(sl()));
  sl.registerLazySingleton(() => LogoutUsecase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      authService: sl(),
    ),
  );

  // Services
  sl.registerLazySingleton(() => AuthService.instance);

  //! Features - Notes
  // Bloc
  sl.registerFactory(
    () => NotesBloc(
      getAllNotes: sl(),
      getNoteById: sl(),
      createNote: sl(),
      updateNote: sl(),
      deleteNote: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAllNotes(sl()));
  sl.registerLazySingleton(() => GetNoteById(sl()));
  sl.registerLazySingleton(() => CreateNote(sl()));
  sl.registerLazySingleton(() => UpdateNote(sl()));
  sl.registerLazySingleton(() => DeleteNote(sl()));

  // Repository
  sl.registerLazySingleton<NotesRepository>(
    () => NotesRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: kIsWeb ? null : sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<NotesRemoteDataSource>(
    () => NotesRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<NotesLocalDataSource>(
    () => NotesLocalDataSourceImpl(notesBox: sl()),
  );

  //! Features - Dashboard
  // Bloc
  sl.registerFactory(
    () => DashboardBloc(),
  );

  // Use cases
  sl.registerLazySingleton(() => GetDashboardStatsUsecase());

  //! Core
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(kIsWeb ? null : sl()),
  );

  sl.registerLazySingleton<LocalStorage>(
    () => LocalStorageImpl(sl()),
  );

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Initialize Hive and register boxes
  await Hive.initFlutter();

  // Register Hive boxes
  final notesBox = await Hive.openBox<Map<dynamic, dynamic>>('notes_box');
  sl.registerLazySingleton(() => notesBox);

  // Register InternetConnectionChecker only for non-web platforms
  if (!kIsWeb) {
    sl.registerLazySingleton(() => InternetConnectionChecker());
  }
}
