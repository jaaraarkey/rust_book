# Contributing to Smart Notes

Thank you for your interest in contributing to Smart Notes! This document provides guidelines for contributing to this Flutter project.

## 🏗️ Architecture Guidelines

This project follows Clean Architecture principles. Please maintain this structure when adding new features:

### Feature Structure
```
features/
└── feature_name/
    ├── data/
    │   ├── datasources/
    │   ├── models/
    │   └── repositories/
    ├── domain/
    │   ├── entities/
    │   ├── repositories/
    │   └── usecases/
    └── presentation/
        ├── bloc/
        ├── pages/
        └── widgets/
```

## 📝 Code Standards

### Linting
- Follow Flutter recommended lints
- All lint warnings must be resolved
- Use `flutter analyze` before committing

### Code Style
- Use super parameters for constructors
- Add `const` constructors where applicable
- Follow Dart naming conventions
- Use meaningful variable and function names

### Example: Modern Constructor Pattern
```dart
// ✅ Good - Super parameters with const
class MyWidget extends StatelessWidget {
  const MyWidget({
    super.key,
    required this.title,
    this.isEnabled = true,
  });

  final String title;
  final bool isEnabled;
}

// ❌ Avoid - Old constructor pattern
class MyWidget extends StatelessWidget {
  const MyWidget({
    Key? key,
    required this.title,
    this.isEnabled = true,
  }) : super(key: key);
}
```

## 🔄 Git Workflow

### Commit Messages
Use conventional commit format:
```
type(scope): description

feat(notes): add note creation functionality
fix(auth): resolve login validation issue
docs(readme): update installation instructions
refactor(core): modernize dependency injection
```

### Branch Naming
- `feature/feature-name` for new features
- `fix/bug-description` for bug fixes
- `docs/documentation-updates` for documentation
- `refactor/component-name` for refactoring

## 🧪 Testing

### Unit Tests
```dart
// Example test structure
group('NoteBloc', () {
  late NoteBloc noteBloc;
  late MockNoteRepository mockRepository;

  setUp(() {
    mockRepository = MockNoteRepository();
    noteBloc = NoteBloc(repository: mockRepository);
  });

  test('should emit loading then success when creating note', () async {
    // Test implementation
  });
});
```

### Widget Tests
```dart
testWidgets('should display note title', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: NoteWidget(note: testNote),
    ),
  );

  expect(find.text('Test Note'), findsOneWidget);
});
```

## 🚀 Development Setup

1. **Fork and Clone**
   ```bash
   git clone https://github.com/your-username/smart_notes.git
   cd smart_notes
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Run Tests**
   ```bash
   flutter test
   ```

4. **Start Development**
   ```bash
   flutter run -d chrome
   ```

## 📱 Platform Considerations

### Web Platform
- Use platform detection for web-specific features
- Handle InternetConnectionChecker carefully
- Test web compatibility thoroughly

### Mobile Platforms
- Follow platform-specific design guidelines
- Test on both iOS and Android
- Consider platform-specific optimizations

## 🔧 Adding New Features

### 1. Feature Planning
- Define the feature scope
- Design the data flow
- Plan the UI components

### 2. Implementation Steps
1. Create feature folder structure
2. Implement domain layer (entities, repositories, use cases)
3. Implement data layer (data sources, models)
4. Implement presentation layer (BLoC, pages, widgets)
5. Add tests
6. Update documentation

### 3. Example: Adding a New Feature
```dart
// 1. Domain Entity
class Note extends Equatable {
  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String content;
  final DateTime createdAt;

  @override
  List<Object> get props => [id, title, content, createdAt];
}

// 2. Repository Contract
abstract class NoteRepository {
  Future<Either<Failure, List<Note>>> getNotes();
  Future<Either<Failure, Note>> createNote(Note note);
}

// 3. Use Case
class CreateNoteUsecase {
  const CreateNoteUsecase(this.repository);

  final NoteRepository repository;

  Future<Either<Failure, Note>> call(Note note) async {
    return await repository.createNote(note);
  }
}
```

## 📚 Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Clean Architecture Guide](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [BLoC Pattern](https://bloclibrary.dev/)
- [Flutter Best Practices](https://docs.flutter.dev/development/data-and-backend/state-mgmt/options)

## ❓ Questions?

Feel free to open an issue for:
- Feature requests
- Bug reports
- Architecture questions
- General discussions

Thank you for contributing to Smart Notes! 🚀
