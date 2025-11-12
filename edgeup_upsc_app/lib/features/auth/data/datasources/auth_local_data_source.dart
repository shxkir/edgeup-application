import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:edgeup_upsc_app/core/constants/app_constants.dart';
import 'package:edgeup_upsc_app/features/auth/data/models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearCache();
  Future<bool> isLoggedIn();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheUser(UserModel user) async {
    await sharedPreferences.setString(
      AppConstants.userIdKey,
      user.id,
    );
    await sharedPreferences.setString(
      AppConstants.userEmailKey,
      user.email,
    );
    await sharedPreferences.setString(
      AppConstants.userNameKey,
      user.name,
    );
    await sharedPreferences.setBool(
      AppConstants.isLoggedInKey,
      true,
    );
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final isLoggedIn = await this.isLoggedIn();
    if (!isLoggedIn) return null;

    final userId = sharedPreferences.getString(AppConstants.userIdKey);
    final userEmail = sharedPreferences.getString(AppConstants.userEmailKey);
    final userName = sharedPreferences.getString(AppConstants.userNameKey);

    if (userId == null || userEmail == null || userName == null) {
      return null;
    }

    return UserModel(
      id: userId,
      email: userEmail,
      name: userName,
    );
  }

  @override
  Future<void> clearCache() async {
    await sharedPreferences.remove(AppConstants.userIdKey);
    await sharedPreferences.remove(AppConstants.userEmailKey);
    await sharedPreferences.remove(AppConstants.userNameKey);
    await sharedPreferences.setBool(AppConstants.isLoggedInKey, false);
  }

  @override
  Future<bool> isLoggedIn() async {
    return sharedPreferences.getBool(AppConstants.isLoggedInKey) ?? false;
  }
}
