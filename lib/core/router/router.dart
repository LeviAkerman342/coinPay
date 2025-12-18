import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/core/router/domain/app_routes.dart';
import 'package:myapp/core/storage/app_storage.dart';
import 'package:myapp/features/auth/presentation/pages/login_page.dart';
import 'package:myapp/features/auth/presentation/pages/register_page.dart';
import 'package:myapp/features/journal/presentation/pages/journal_page.dart';
import 'package:myapp/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:myapp/features/request_money/presentation/pages/request_money_page.dart';
import 'package:myapp/features/send_money/presentation/pages/scan_qr_page.dart';
import 'package:myapp/features/send_money/presentation/pages/send_money_page.dart';
import 'package:myapp/features/spending/presentation/pages/spending_detail_page.dart';
import 'package:myapp/features/splash/presentation/pages/splash_page.dart';
import 'package:myapp/features/support/presentation/pages/support_page.dart';
import 'package:myapp/shared/widgets/scaffold_with_bottom_nav.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: AppRoutes.register,
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: AppRoutes.sendMoney,
      builder: (context, state) => const SendMoneyPage(),
    ),
    GoRoute(
      path: AppRoutes.scanQr,
      builder: (context, state) => const ScanQrPage(),
    ),
    GoRoute(
      path: AppRoutes.requestMoney,
      builder: (context, state) => const RequestMoneyPage(),
    ),
    GoRoute(
      path: AppRoutes.spendingDetail,
      builder: (context, state) => const SpendingDetailPage(),
    ),
    GoRoute(
      path: AppRoutes.support,
      builder: (context, state) => const SupportPage(),
    ),
    // Главный shell с Bottom Nav
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          ScaffoldWithBottomNav(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.journal,
              name: AppRoutes.journal,
              builder: (context, state) => const JournalPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/analytics', // пока заглушка
              builder: (context, state) =>
                  const Scaffold(body: Center(child: Text('Analytics'))),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/add-transaction',
              builder: (context, state) =>
                  const Scaffold(body: Center(child: Text('Add Transaction'))),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/notifications',
              builder: (context, state) =>
                  const Scaffold(body: Center(child: Text('Notifications'))),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.profile,
              builder: (context, state) =>
                  const Scaffold(body: Center(child: Text('Profile'))),
            ),
          ],
        ),
      ],
    ),
  ],

  redirect: (context, state) {
    final bool firstLaunch = AppStorage.isFirstLaunch();
    final bool loggedIn = AppStorage.isLoggedIn();

    final String location = state.matchedLocation;

    if (location == AppRoutes.splash || location == '/') {
      if (firstLaunch) return AppRoutes.onboarding;
      if (!loggedIn) return AppRoutes.login;
      return AppRoutes.journal;
    }
    return null;
  },
);
