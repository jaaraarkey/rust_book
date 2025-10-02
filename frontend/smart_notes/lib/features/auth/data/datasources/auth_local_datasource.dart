import '../../../../core/constants/storage_keys.dart';
import '../../../../core/storage/local_storage.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheAuthResponse(AuthResponseModel authResponse);
  Future<AuthResponseModel?> getCachedAuthResponse();
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearAuthData();
  Future<bool> isLoggedIn();
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final LocalStorage localStorage;

  AuthLocalDataSourceImpl({
    required this.localStorage,
  });

  @override
  Future<void> cacheAuthResponse(AuthResponseModel authResponse) async {
    // Store tokens and user info in local storage
    await localStorage.setString(
        StorageKeys.accessToken, authResponse.accessToken);
    await localStorage.setString(
        StorageKeys.refreshToken, authResponse.refreshToken);

    // Store user info in local storage
    await localStorage.setObject(StorageKeys.cachedUserProfile,
        (authResponse.user as UserModel).toJson());
    await localStorage.setBool(StorageKeys.isLoggedIn, true);
    await localStorage.setString(StorageKeys.userId, authResponse.user.id);
    await localStorage.setString(
        StorageKeys.userEmail, authResponse.user.email);
    await localStorage.setString(StorageKeys.userName, authResponse.user.name);
  }

  @override
  Future<AuthResponseModel?> getCachedAuthResponse() async {
    try {
      final accessToken = await localStorage.getString(StorageKeys.accessToken);
      final refreshToken =
          await localStorage.getString(StorageKeys.refreshToken);
      final userJson =
          await localStorage.getObject(StorageKeys.cachedUserProfile);

      if (accessToken == null || refreshToken == null || userJson == null) {
        return null;
      }

      final user = UserModel.fromJson(userJson);

      return AuthResponseModel(
        user: user,
        accessToken: accessToken,
        refreshToken: refreshToken,
        expiresAt:
            DateTime.now().add(const Duration(hours: 24)), // Default expiry
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    await localStorage.setObject(StorageKeys.cachedUserProfile, user.toJson());
    await localStorage.setString(StorageKeys.userId, user.id);
    await localStorage.setString(StorageKeys.userEmail, user.email);
    await localStorage.setString(StorageKeys.userName, user.name);
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final userJson =
          await localStorage.getObject(StorageKeys.cachedUserProfile);
      if (userJson == null) return null;
      return UserModel.fromJson(userJson);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> clearAuthData() async {
    // Clear local storage
    await localStorage.remove(StorageKeys.accessToken);
    await localStorage.remove(StorageKeys.refreshToken);
    await localStorage.remove(StorageKeys.cachedUserProfile);
    await localStorage.remove(StorageKeys.isLoggedIn);
    await localStorage.remove(StorageKeys.userId);
    await localStorage.remove(StorageKeys.userEmail);
    await localStorage.remove(StorageKeys.userName);
  }

  @override
  Future<bool> isLoggedIn() async {
    final isLoggedIn =
        await localStorage.getBool(StorageKeys.isLoggedIn) ?? false;
    final accessToken = await localStorage.getString(StorageKeys.accessToken);
    return isLoggedIn && accessToken != null;
  }

  @override
  Future<String?> getAccessToken() async {
    return await localStorage.getString(StorageKeys.accessToken);
  }

  @override
  Future<String?> getRefreshToken() async {
    return await localStorage.getString(StorageKeys.refreshToken);
  }
}
