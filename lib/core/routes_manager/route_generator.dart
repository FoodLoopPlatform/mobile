import 'package:flutter/material.dart';
import 'package:foodloop/core/routes_manager/routes_names.dart';
import 'package:foodloop/features/auth/presentation/views/business_details_view.dart';
import 'package:foodloop/features/auth/presentation/views/create_account_view.dart';
import 'package:foodloop/features/auth/presentation/views/email_verification_view.dart';
import 'package:foodloop/features/auth/presentation/views/forgot_password_view.dart';
import 'package:foodloop/features/auth/presentation/views/login_view.dart';
import 'package:foodloop/features/auth/presentation/views/reset_password_view.dart';
import 'package:foodloop/features/navigation/presentation/views/main_navigation_view.dart';
import 'package:foodloop/features/onboarding/presentation/views/welcome_view.dart';
import 'package:foodloop/features/profile/presentation/views/profile_view.dart';

class RouteGenerator {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case RoutesNames.welcomeView:
        return MaterialPageRoute(builder: (_) => const WelcomeView());

      case RoutesNames.createAccountView:
        return MaterialPageRoute(builder: (_) => const CreateAccountView());

      case RoutesNames.businessDetailsView:
        return MaterialPageRoute(builder: (_) => const BusinessDetailsView());

      case RoutesNames.emailVerificationView:
        final String email = settings.arguments as String? ?? '';
        return MaterialPageRoute(
          builder: (_) => EmailVerificationView(email: email),
        );

      case RoutesNames.loginView:
        return MaterialPageRoute(builder: (_) => const LoginView());

      case RoutesNames.forgotPasswordView:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordView());

      case RoutesNames.resetPasswordView:
        return MaterialPageRoute(builder: (_) => const ResetPasswordView());

      case RoutesNames.profileView:
        return MaterialPageRoute(builder: (_) => const ProfileView());
      case RoutesNames.mainNav:
        return MaterialPageRoute(builder: (_) => const MainNavigationView());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
