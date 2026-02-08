import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/api_constants.dart';
import '../providers/api_provider.dart';
import '../models/user_model.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.read(dioProvider));
});

class AuthRepository {
  final Dio _dio;

  AuthRepository(this._dio);

  String _parseErrorMessage(DioException e) {
    // 백엔드에서 보내는 상세 에러 메시지 추출
    if (e.response?.data is Map) {
      final detail = e.response?.data['detail'];
      if (detail is String) {
        return detail;
      }
    }
    // 기본 에러 메시지
    return '네트워크 오류가 발생했습니다. 다시 시도해주세요.';
  }

  Future<void> sendVerificationEmail(String email) async {
    try {
      await _dio.post(
        '${ApiConstants.auth}/email-verification/send',
        data: {'email': email},
      );
    } on DioException catch (e) {
      throw _parseErrorMessage(e);
    }
  }

  Future<Map<String, dynamic>> verifyCode(String email, String code) async {
    try {
      final response = await _dio.post(
        '${ApiConstants.auth}/email-verification/verify',
        data: {'email': email, 'code': code},
      );
      return response.data; // { "access_token": "...", "is_new_user": bool }
    } on DioException catch (e) {
      throw _parseErrorMessage(e);
    }
  }

  Future<UserModel> getMe() async {
    try {
      final response = await _dio.get('${ApiConstants.users}/me');
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _parseErrorMessage(e);
    }
  }

  Future<void> completeOnboarding(Map<String, dynamic> data) async {
    try {
      await _dio.post('${ApiConstants.auth}/onboarding/complete');
    } on DioException catch (e) {
      throw _parseErrorMessage(e);
    }
  }
}
