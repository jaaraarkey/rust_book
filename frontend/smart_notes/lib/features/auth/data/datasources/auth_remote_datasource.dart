import '../models/auth_response_model.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  });

  Future<AuthResponseModel> register({
    required String email,
    required String password,
    required String name,
  });

  Future<void> logout();

  Future<AuthResponseModel> refreshToken({
    required String refreshToken,
  });

  Future<UserModel> getCurrentUser();

  Future<void> forgotPassword({
    required String email,
  });

  Future<void> resetPassword({
    required String token,
    required String newPassword,
  });

  Future<void> verifyEmail({
    required String token,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl();

  @override
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    // Mock successful login
    return AuthResponseModel(
      user: UserModel(
        id: '1',
        email: email,
        name: 'John Doe',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isEmailVerified: true,
      ),
      accessToken: 'mock_access_token',
      refreshToken: 'mock_refresh_token',
      expiresAt: DateTime.now().add(const Duration(hours: 24)),
    );
  }

  @override
  Future<AuthResponseModel> register({
    required String email,
    required String password,
    required String name,
  }) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    // Mock successful registration
    return AuthResponseModel(
      user: UserModel(
        id: '1',
        email: email,
        name: name,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isEmailVerified: false,
      ),
      accessToken: 'mock_access_token',
      refreshToken: 'mock_refresh_token',
      expiresAt: DateTime.now().add(const Duration(hours: 24)),
    );
  }

  @override
  Future<void> logout() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<AuthResponseModel> refreshToken({
    required String refreshToken,
  }) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Mock token refresh
    return AuthResponseModel(
      user: UserModel(
        id: '1',
        email: 'user@example.com',
        name: 'John Doe',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isEmailVerified: true,
      ),
      accessToken: 'new_mock_access_token',
      refreshToken: 'new_mock_refresh_token',
      expiresAt: DateTime.now().add(const Duration(hours: 24)),
    );
  }

  @override
  Future<UserModel> getCurrentUser() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    return UserModel(
      id: '1',
      email: 'user@example.com',
      name: 'John Doe',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isEmailVerified: true,
    );
  }

  @override
  Future<void> forgotPassword({
    required String email,
  }) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<void> verifyEmail({
    required String token,
  }) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
  }
}
