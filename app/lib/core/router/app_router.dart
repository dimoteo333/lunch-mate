import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../presentation/auth/login_screen.dart';
import '../../presentation/auth/verify_screen.dart';
import '../../presentation/auth/onboarding/onboarding_screen.dart';
import '../../presentation/home/home_screen.dart';
import '../../presentation/profile/profile_screen.dart';
import '../../presentation/party/party_create_screen.dart';
import '../../presentation/party/party_detail_screen.dart';
import '../../presentation/chat/chat_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/verify',
      builder: (context, state) {
        // extra로 email 전달 받음
        final email = state.extra as String?;
        return VerifyScreen(email: email ?? '');
      },
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/party/create',
      builder: (context, state) => const PartyCreateScreen(),
    ),
    GoRoute(
      path: '/party/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return PartyDetailScreen(partyId: id);
      },
    ),
    GoRoute(
      path: '/chat/:roomId',
      builder: (context, state) {
        final roomId = state.pathParameters['roomId']!;
        return ChatScreen(roomId: roomId);
      },
    ),
  ],
);
