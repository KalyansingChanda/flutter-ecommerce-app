import '../models/user.dart';

class UserService {
  // Mock service for non-Firebase version

  Future<AppUser?> getUser(String uid) async {
    try {
      // Mock implementation - return null for now
      await Future.delayed(const Duration(milliseconds: 500));
      return null;
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  Future<void> createUser(AppUser user) async {
    try {
      // Mock implementation
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  Future<void> updateUser(AppUser user) async {
    try {
      // Mock implementation
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  Stream<AppUser?> getUserStream(String uid) {
    // Mock implementation - return null stream
    return Stream.value(null);
  }
}