import 'package:flutter/material.dart';
import 'app.dart';
import 'injection_container.dart' as di;
import 'core/data/sample_data_manager.dart';

void main() async {
  print('🚀 STARTING SMART NOTES APP');
  WidgetsFlutterBinding.ensureInitialized();

  print('🔧 Initializing dependency injection...');
  // Initialize dependency injection
  await di.init();

  print('📚 Initializing sample data...');
  // Initialize sample data for testing
  // For debugging: clear existing data and reinitialize
  await SampleDataManager.clearAllNotes();
  await SampleDataManager.initializeSampleData();

  print('▶️ Running app...');
  runApp(const MyApp());
}
