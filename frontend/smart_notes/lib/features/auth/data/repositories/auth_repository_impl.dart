import 'package:dartz/dartz.dart';
import '../../../../core/auth/auth_service.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/auth_response.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService authService;

  AuthRepositoryImpl({required this.authService});

  @override
  Future<Either<Failure, AuthResponse>> login({
    required String email,
    required String password,
  }) async {
    final result = await authService.login(email: email, password: password);

    return result.fold(
      (failure) => Left(failure),
      (authResult) => Right(
        AuthResponse(
          user: User(
            id: authResult.user.id,
            email: authResult.user.email,
            name: authResult.user.fullName,
            createdAt: authResult.user.createdAt,
            updatedAt: authResult.user.updatedAt ?? DateTime.now(),
            isEmailVerified: authResult.user.isActive,
          ),
          accessToken: authResult.token,
          refreshToken: '', // Not provided by current backend
          expiresAt: DateTime.now().add(const Duration(hours: 24)),
        ),
      ),
    );
  }

  @override
  Future<Either<Failure, AuthResponse>> register({
    required String email,
    required String password,
    required String name,
  }) async {
    final result = await authService.register(
      email: email,
      password: password,
      fullName: name,
    );

    return result.fold(
      (failure) => Left(failure),
      (authResult) => Right(
        AuthResponse(
          user: User(
            id: authResult.user.id,
            email: authResult.user.email,
            name: authResult.user.fullName,
            createdAt: authResult.user.createdAt,
            updatedAt: authResult.user.updatedAt ?? DateTime.now(),
            isEmailVerified: authResult.user.isActive,
          ),
          accessToken: authResult.token,
          refreshToken: '', // Not provided by current backend
          expiresAt: DateTime.now().add(const Duration(hours: 24)),
        ),
      ),
    );
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await authService.logout();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Logout failed: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    final result = await authService.getCurrentUser();

    return result.fold(
      (failure) => Left(failure),
      (authUser) => Right(
        User(
          id: authUser.id,
          email: authUser.email,
          name: authUser.fullName,
          createdAt: authUser.createdAt,
          updatedAt: authUser.updatedAt ?? DateTime.now(),
          isEmailVerified: authUser.isActive,
        ),
      ),
    );
  }

  @override
  Future<Either<Failure, AuthResponse>> refreshToken() async {
    // For now, just return current user if authenticated
    final isAuth = await authService.isAuthenticated();
    if (!isAuth) {
      return const Left(ServerFailure('Not authenticated'));
    }

    final userResult = await getCurrentUser();
    return userResult.fold(
      (failure) => Left(failure),
      (user) => Right(
        AuthResponse(
          user: user,
          accessToken: '', // Token is managed internally by AuthService
          refreshToken: '',
          expiresAt: DateTime.now().add(const Duration(hours: 24)),
        ),
      ),
    );
  }

  @override
  Future<Either<Failure, void>> forgotPassword({
    required String email,
  }) async {
    // Not implemented in backend yet
    return const Left(ServerFailure('Forgot password not implemented'));
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    // Not implemented in backend yet
    return const Left(ServerFailure('Reset password not implemented'));
  }

  @override
  Future<Either<Failure, void>> verifyEmail({
    required String token,
  }) async {
    // Not implemented in backend yet
    return const Left(ServerFailure('Email verification not implemented'));
  }

  @override
  Future<bool> isLoggedIn() async {
    return await authService.isAuthenticated();
  }

  @override
  Future<String?> getAccessToken() async {
    // The AuthService manages tokens internally
    // This would need to be exposed if needed
    return null;
  }
}
