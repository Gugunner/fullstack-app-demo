import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:piix_mobile/app_bootstrap.dart';
import 'package:piix_mobile/src/common_widgets/common_widgets_barrel_file.dart';
import 'package:piix_mobile/src/features/agreements/presentation/agreements_barrel_file.dart';
import 'package:piix_mobile/src/features/authentication/application/auth_service_barrel_file.dart';
import 'package:piix_mobile/src/features/authentication/presentation/authentication_page_barrel_file.dart';
import 'package:piix_mobile/src/routing/go_router_refresh_stream.dart';
import 'package:piix_mobile/src/routing/home_page.dart';
import 'package:piix_mobile/src/utils/verification_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

/// The routes of the app.
enum AppRoute {
  welcome('/'),
  home('/home'),
  signIn('/sign_in'),
  signUp('/sign_up'),
  termsOfService('terms_of_service'),
  privacyPolicy('privacy_policy'),
  verification('verification'),
  signInVerification('sign_in_verification'),
  signUpVerification('sign_up_verification');

  const AppRoute(this.path);

  ///The actual path of the route
  final String path;

  static List<String> get unauthRoutes => [
        signIn.path,
        signUp.path,
        termsOfService.path,
        privacyPolicy.path,
        verification.path,
        signInVerification.path,
        signUpVerification.path,
      ];
}

@Riverpod(keepAlive: true)
final goRouterProvider = Provider<GoRouter>((ref) {
  // * Get the [AuthService] instance
  final authService = ref.watch(authServiceProvider);
  // * Get if the app is running on a mobile or tablet device
  final isWeb = ref.watch(isWebProvider);
  return GoRouter(
    initialLocation: AppRoute.welcome.path,
    debugLogDiagnostics: true,
    redirect: (context, state) async {
      final user = authService.currentUser;
      final isLoggedIn = user != null;
      // * Redirect the user to the appropriate page based on the platform
      //TODO: Add hasVerifiedDocumentation from provider
      if (isWeb) return _redirectWeb(context, state, isLoggedIn);
      return _redirectMobileAndTablet(context, state, isLoggedIn);
    },
    refreshListenable: GoRouterRefreshStream(authService.authStateChange()),
    routes: [
      GoRoute(
        path: AppRoute.welcome.path,
        name: AppRoute.welcome.name,
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: WelcomePage(),
          );
        },
        routes: [
          GoRoute(
            path: '${AppRoute.verification.path}/:email',
            name: AppRoute.verification.name,
            pageBuilder: (context, state) {
              final email = state.pathParameters['email']!;
              return MaterialPage(
                child: EmailVerificationCodePage(email: email),
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: AppRoute.signUp.path,
        name: AppRoute.signUp.name,
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: SignUpPage(),
          );
        },
        routes: [
          GoRoute(
            path: '${AppRoute.signUpVerification.path}/:email',
            name: AppRoute.signUpVerification.name,
            pageBuilder: (context, state) {
              final email = state.pathParameters['email']!;
              return MaterialPage(
                child: EmailVerificationCodePage(
                  email: email,
                  verificationType: VerificationType.register,
                ),
              );
            },
          ),
          GoRoute(
            path: AppRoute.termsOfService.path,
            name: AppRoute.termsOfService.name,
            pageBuilder: (context, state) {
              return const MaterialPage(
                child: TermsOfServicePage(),
              );
            },
          ),
          GoRoute(
            path: AppRoute.privacyPolicy.path,
            name: AppRoute.privacyPolicy.name,
            pageBuilder: (context, state) {
              return const MaterialPage(
                child: PrivacyPolicyPage(),
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: AppRoute.signIn.path,
        name: AppRoute.signIn.name,
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: SignInPage(),
          );
        },
        routes: [
          GoRoute(
            path: '${AppRoute.signInVerification.path}/:email',
            name: AppRoute.signInVerification.name,
            pageBuilder: (context, state) {
              final email = state.pathParameters['email']!;
              return MaterialPage(
                child: EmailVerificationCodePage(email: email),
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: AppRoute.home.path,
        name: AppRoute.home.name,
        pageBuilder: (context, state) {
          return const MaterialPage(
            child: HomePage(),
          );
        },
      ),
    ],
    errorBuilder: (context, state) => const LostPage(),
  );
});

//TODO: Implement the _redirectMobileAndTablet method
FutureOr<String?> _redirectMobileAndTablet(
    BuildContext context, GoRouterState state, bool isLoggedIn) async {
  final path = state.uri.path;
  if (!isLoggedIn &&
      !AppRoute.unauthRoutes.any((route) => path.contains(route))) {
    return AppRoute.welcome.path;
  }
  return null;
}

FutureOr<String?> _redirectWeb(
    BuildContext context, GoRouterState state, bool isLoggedIn) async {
  final path = state.uri.path;

  if (!isLoggedIn &&
      !AppRoute.unauthRoutes.any((route) => path.contains(route))) {
    return AppRoute.welcome.path;
  }
  //TODO: Check if this condition can replace _navigateToVerificationCodePage
  if (path == AppRoute.signInVerification.path &&
      state.matchedLocation == AppRoute.welcome.path) {
    return AppRoute.verification.path;
  }
  if (isLoggedIn && path == '/') return AppRoute.home.path;
  return null;
}
