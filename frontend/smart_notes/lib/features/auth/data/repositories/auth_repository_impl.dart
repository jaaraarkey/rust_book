import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/auth_response.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, AuthResponse>> login({
    required String email,
    required String password,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteAuthResponse = await remoteDataSource.login(
          email: email,
          password: password,
        );

        // Cache the auth response locally
        await localDataSource.cacheAuthResponse(remoteAuthResponse);

        return Right(remoteAuthResponse);
      } on UnauthorizedException catch (e) {
        return Left(UnauthorizedFailure(e.message));
      } on NotFoundException catch (e) {
        return Left(NotFoundFailure(e.message));
      } on TimeoutException catch (e) {
        return Left(TimeoutFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return const Left(UnknownFailure('An unexpected error occurred'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, AuthResponse>> register({
    required String email,
    required String password,
    required String name,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteAuthResponse = await remoteDataSource.register(
          email: email,
          password: password,
          name: name,
        );

        // Cache the auth response locally
        await localDataSource.cacheAuthResponse(remoteAuthResponse);

        return Right(remoteAuthResponse);
      } on ValidationException catch (e) {
        return Left(ValidationFailure(e.message));
      } on TimeoutException catch (e) {
        return Left(TimeoutFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return const Left(UnknownFailure('An unexpected error occurred'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      // Try to logout from server first
      if (await networkInfo.isConnected) {
        try {
          await remoteDataSource.logout();
        } catch (e) {
          // Don't fail local logout if remote logout fails
        }
      }

      // Always clear local auth data
      await localDataSource.clearAuthData();

      return const Right(null);
    } catch (e) {
      return const Left(UnknownFailure('Failed to logout'));
    }
  }

  @override
  Future<Either<Failure, AuthResponse>> refreshToken() async {
    if (await networkInfo.isConnected) {
      try {
        final refreshToken = await localDataSource.getRefreshToken();
        if (refreshToken == null) {
          return const Left(UnauthorizedFailure('No refresh token available'));
        }

        final remoteAuthResponse = await remoteDataSource.refreshToken(
          refreshToken: refreshToken,
        );

        // Cache the new auth response locally
        await localDataSource.cacheAuthResponse(remoteAuthResponse);

        return Right(remoteAuthResponse);
      } on UnauthorizedException catch (e) {
        // Clear local auth data if refresh token is invalid
        await localDataSource.clearAuthData();
        return Left(UnauthorizedFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return const Left(UnknownFailure('An unexpected error occurred'));
      }
    } else {
      // Try to get cached auth response when offline
      try {
        final cachedAuthResponse =
            await localDataSource.getCachedAuthResponse();
        if (cachedAuthResponse != null) {
          return Right(cachedAuthResponse);
        } else {
          return const Left(
              NetworkFailure('No internet connection and no cached data'));
        }
      } catch (e) {
        return const Left(CacheFailure('Failed to retrieve cached auth data'));
      }
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteUser = await remoteDataSource.getCurrentUser();

        // Cache the user locally
        await localDataSource.cacheUser(remoteUser);

        return Right(remoteUser);
      } on UnauthorizedException catch (e) {
        return Left(UnauthorizedFailure(e.message));
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return const Left(UnknownFailure('An unexpected error occurred'));
      }
    } else {
      // Try to get cached user when offline
      try {
        final cachedUser = await localDataSource.getCachedUser();
        if (cachedUser != null) {
          return Right(cachedUser);
        } else {
          return const Left(
              NetworkFailure('No internet connection and no cached user data'));
        }
      } catch (e) {
        return const Left(CacheFailure('Failed to retrieve cached user data'));
      }
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword({
    required String email,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.forgotPassword(email: email);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return const Left(UnknownFailure('An unexpected error occurred'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.resetPassword(
          token: token,
          newPassword: newPassword,
        );
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return const Left(UnknownFailure('An unexpected error occurred'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> verifyEmail({
    required String token,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.verifyEmail(token: token);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return const Left(UnknownFailure('An unexpected error occurred'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return await localDataSource.isLoggedIn();
  }

  @override
  Future<String?> getAccessToken() async {
    return await localDataSource.getAccessToken();
  }
}
