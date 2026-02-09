import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'core/constants/api_constants.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env file
  await dotenv.load(fileName: 'app/.env');

  AuthRepository.initialize(appKey: ApiConstants.kakaoJsApiKey);
  runApp(const ProviderScope(child: LunchMateApp()));
}
