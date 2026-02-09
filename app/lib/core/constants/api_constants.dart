import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  // Android Emulator: 10.0.2.2, iOS Simulator: 127.0.0.1
  static const String baseUrl = 'http://127.0.0.1:8000/api/v1';

  static const String auth = '/auth';
  static const String users = '/users';
  static const String parties = '/parties';
  static const String chat = '/chat';
  static const String reviews = '/reviews';

  // Kakao API
  static const String kakaoBaseUrl = 'https://dapi.kakao.com';
  static const String kakaoKeywordSearch = '/v2/local/search/keyword.json';
  static const String kakaoCategorySearch = '/v2/local/search/category.json';
  static const String kakaoCoord2Region = '/v2/local/geo/coord2regioncode.json';

  // Kakao API Keys (loaded from .env)
  static String get kakaoRestApiKey =>
      dotenv.env['KAKAO_REST_API_KEY'] ?? 'YOUR_KAKAO_REST_API_KEY';
  static String get kakaoJsApiKey =>
      dotenv.env['KAKAO_JS_API_KEY'] ?? 'YOUR_KAKAO_JS_API_KEY';
  static String get kakaoNativeAppKey =>
      dotenv.env['KAKAO_NATIVE_APP_KEY'] ?? 'YOUR_KAKAO_NATIVE_APP_KEY';
}
