import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../data/models/user_model.dart';
import '../data/repositories/auth_repository.dart';
import '../data/providers/storage_provider.dart';

// 상태 클래스 정의
class AuthState {
  final bool isLoading;
  final UserModel? user;
  final String? error;

  AuthState({this.isLoading = false, this.user, this.error});

  AuthState copyWith({bool? isLoading, UserModel? user, String? error}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error,
    );
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    ref.read(authRepositoryProvider),
    ref.read(secureStorageProvider),
  );
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;
  final FlutterSecureStorage _storage;

  AuthNotifier(this._repository, this._storage) : super(AuthState()) {
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final token = await _storage.read(key: 'access_token');
    if (token != null) {
      try {
        final user = await _repository.getMe();
        state = state.copyWith(user: user);
      } catch (e) {
        // 토큰이 유효하지 않으면 로그아웃
        await logout();
      }
    }
  }

  Future<void> sendVerification(String email) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.sendVerificationEmail(email);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<bool> verifyCode(String email, String code) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final result = await _repository.verifyCode(email, code);
      final token = result['access_token'];
      final isNewUser = result['is_new_user'] ?? false;

      await _storage.write(key: 'access_token', value: token);
      
      if (!isNewUser) {
        final user = await _repository.getMe();
        state = state.copyWith(user: user);
      }
      
      return isNewUser;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> completeOnboarding(Map<String, dynamic> data) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.completeOnboarding(data);
      final user = await _repository.getMe();
      state = state.copyWith(user: user);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'access_token');
    state = AuthState();
  }
}
