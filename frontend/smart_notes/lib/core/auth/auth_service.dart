import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:dartz/dartz.dart';
import '../error/failures.dart';
import '../graphql/graphql_config.dart';
import '../graphql/graphql_queries.dart';

class AuthService {
  static AuthService? _instance;
  static AuthService get instance => _instance ??= AuthService._();
  AuthService._();

  Future<GraphQLClient> get graphqlClient async => await GraphQLConfig.client;

  // Predefined test users for development
  static final Map<String, Map<String, dynamic>> _testUsers = {
    'john@example.com': {
      'id': 'user-001',
      'email': 'john@example.com',
      'password': 'password123',
      'fullName': 'John Doe',
      'createdAt': DateTime(2024, 1, 15),
      'isActive': true,
    },
    'jane@example.com': {
      'id': 'user-002',
      'email': 'jane@example.com',
      'password': 'secret456',
      'fullName': 'Jane Smith',
      'createdAt': DateTime(2024, 2, 20),
      'isActive': true,
    },
    'admin@smartnotes.com': {
      'id': 'user-003',
      'email': 'admin@smartnotes.com',
      'password': 'admin123',
      'fullName': 'Admin User',
      'createdAt': DateTime(2024, 1, 1),
      'isActive': true,
    },
    'alice@test.com': {
      'id': 'user-004',
      'email': 'alice@test.com',
      'password': 'test123',
      'fullName': 'Alice Johnson',
      'createdAt': DateTime(2024, 3, 10),
      'isActive': true,
    },
  };

  // Register new user
  Future<Either<Failure, AuthResult>> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      // For development: simulate successful registration
      if (email.isNotEmpty && password.isNotEmpty && fullName.isNotEmpty) {
        final mockUser = AuthUser(
          id: 'mock-user-id-${DateTime.now().millisecondsSinceEpoch}',
          email: email,
          fullName: fullName,
          createdAt: DateTime.now(),
          isActive: true,
        );

        final mockToken =
            'mock-jwt-token-${DateTime.now().millisecondsSinceEpoch}';

        // Save token
        await GraphQLConfig.saveToken(mockToken);

        return Right(AuthResult(
          token: mockToken,
          user: mockUser,
        ));
      }

      final graphQLClient = await graphqlClient;
      final result = await graphQLClient.mutate(
        MutationOptions(
          document: gql(registerMutation),
          variables: {
            'input': {
              'email': email,
              'password': password,
              'fullName': fullName,
            },
          },
        ),
      );

      if (result.hasException) {
        return Left(ServerFailure(
          result.exception?.toString() ?? 'Registration failed',
        ));
      }

      final data = result.data?['register'];
      if (data == null) {
        return const Left(ServerFailure('Registration failed'));
      }

      final token = data['token'] as String;
      final userData = data['user'] as Map<String, dynamic>;

      // Save token
      await GraphQLConfig.saveToken(token);

      return Right(AuthResult(
        token: token,
        user: AuthUser.fromJson(userData),
      ));
    } catch (e) {
      return Left(ServerFailure('Registration failed: $e'));
    }
  }

  // Login user
  Future<Either<Failure, AuthResult>> login({
    required String email,
    required String password,
  }) async {
    try {
      // Check predefined test users first
      if (_testUsers.containsKey(email)) {
        final testUser = _testUsers[email]!;
        if (testUser['password'] == password) {
          final mockUser = AuthUser(
            id: testUser['id'],
            email: testUser['email'],
            fullName: testUser['fullName'],
            createdAt: testUser['createdAt'],
            isActive: testUser['isActive'],
          );

          final mockToken =
              'mock-jwt-token-${testUser['id']}-${DateTime.now().millisecondsSinceEpoch}';
          await GraphQLConfig.saveToken(mockToken);

          return Right(AuthResult(
            token: mockToken,
            user: mockUser,
          ));
        } else {
          return const Left(ServerFailure('Invalid email or password'));
        }
      }

      // For development: allow any other email/password combination
      if (email.isNotEmpty && password.isNotEmpty) {
        final mockUser = AuthUser(
          id: 'mock-user-id-${DateTime.now().millisecondsSinceEpoch}',
          email: email,
          fullName: 'Test User',
          createdAt: DateTime.now(),
          isActive: true,
        );

        final mockToken =
            'mock-jwt-token-${DateTime.now().millisecondsSinceEpoch}';

        // Save token
        await GraphQLConfig.saveToken(mockToken);

        return Right(AuthResult(
          token: mockToken,
          user: mockUser,
        ));
      }

      final graphQLClient = await graphqlClient;
      final result = await graphQLClient.mutate(
        MutationOptions(
          document: gql(loginMutation),
          variables: {
            'input': {
              'email': email,
              'password': password,
            },
          },
        ),
      );

      if (result.hasException) {
        return Left(ServerFailure(
          result.exception?.toString() ?? 'Login failed',
        ));
      }

      final data = result.data?['login'];
      if (data == null) {
        return const Left(ServerFailure('Login failed'));
      }

      final token = data['token'] as String;
      final userData = data['user'] as Map<String, dynamic>;

      // Save token
      await GraphQLConfig.saveToken(token);

      return Right(AuthResult(
        token: token,
        user: AuthUser.fromJson(userData),
      ));
    } catch (e) {
      return Left(ServerFailure('Login failed: $e'));
    }
  }

  // Get current user
  Future<Either<Failure, AuthUser>> getCurrentUser() async {
    try {
      final token = await GraphQLConfig.getToken();
      if (token != null && token.startsWith('mock-jwt-token')) {
        // Return mock user for development
        final mockUser = AuthUser(
          id: 'mock-user-id',
          email: 'test@example.com',
          fullName: 'Test User',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          isActive: true,
        );
        return Right(mockUser);
      }

      final graphQLClient = await graphqlClient;
      final result = await graphQLClient.query(
        QueryOptions(
          document: gql(getMeQuery),
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      if (result.hasException) {
        return Left(ServerFailure(
          result.exception?.toString() ?? 'Failed to get user',
        ));
      }

      final data = result.data?['me'];
      if (data == null) {
        return const Left(ServerFailure('User not found'));
      }

      return Right(AuthUser.fromJson(data as Map<String, dynamic>));
    } catch (e) {
      return Left(ServerFailure('Failed to get user: $e'));
    }
  }

  // Logout user
  Future<void> logout() async {
    await GraphQLConfig.removeToken();
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    return await GraphQLConfig.isAuthenticated();
  }
}

class AuthResult {
  final String token;
  final AuthUser user;

  AuthResult({
    required this.token,
    required this.user,
  });
}

class AuthUser {
  final String id;
  final String email;
  final String fullName;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isActive;

  AuthUser({
    required this.id,
    required this.email,
    required this.fullName,
    required this.createdAt,
    this.updatedAt,
    this.isActive = true,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isActive': isActive,
    };
  }
}
