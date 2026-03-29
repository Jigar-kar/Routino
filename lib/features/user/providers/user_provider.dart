import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

final userServiceProvider = Provider((ref) => UserService());

class UserNotifier extends Notifier<UserModel?> {
  @override
  UserModel? build() {
    return null; // Will be loaded via stream
  }

  Future<void> saveUser(UserModel user) async {
    final service = ref.read(userServiceProvider);
    await service.saveUser(user);
    state = user;
  }

  Future<void> updateUser(UserModel user) async {
    final service = ref.read(userServiceProvider);
    await service.updateUser(user);
    state = user;
  }

  Future<void> deleteUser(String userId) async {
    final service = ref.read(userServiceProvider);
    await service.deleteUser(userId);
    state = null;
  }
}

final userProvider = NotifierProvider<UserNotifier, UserModel?>(() {
  return UserNotifier();
});

final userStreamProvider = StreamProvider<UserModel?>((ref) {
  final service = ref.watch(userServiceProvider);
  return service.getUserStream();
});