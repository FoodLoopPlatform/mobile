import 'package:flutter/material.dart';
import 'package:foodloop/core/routes_manager/routes_names.dart';
import 'package:foodloop/features/add_product/data/models/product_draft.dart';
import 'package:foodloop/features/add_product/presentation/views/add_product_view.dart';
import 'package:foodloop/features/add_product/presentation/views/expiration_details_view.dart';
import 'package:foodloop/features/add_product/presentation/views/scanning_view.dart';
import 'package:foodloop/features/add_product/presentation/views/verification_results_view.dart';
import 'package:foodloop/features/auth/presentation/views/business_details/business_details_view.dart';
import 'package:foodloop/features/auth/presentation/views/create_account/create_account_view.dart';
import 'package:foodloop/features/auth/presentation/views/email_verification/email_verification_view.dart';
import 'package:foodloop/features/auth/presentation/views/forgot_password/forgot_password_view.dart';
import 'package:foodloop/features/auth/presentation/views/login/login_view.dart';
import 'package:foodloop/features/auth/presentation/views/reset_password/reset_password_view.dart';
import 'package:foodloop/features/market/data/models/product_model.dart';
import 'package:foodloop/features/market/presentation/views/product_details_view.dart';
import 'package:foodloop/features/search/presentation/views/search_view.dart';
import 'package:foodloop/features/navigation/presentation/views/main_navigation_view.dart';
import 'package:foodloop/features/onboarding/presentation/views/welcome_view.dart';
import 'package:foodloop/features/profile/data/models/address_model.dart';
import 'package:foodloop/features/orders/data/models/order_model.dart';
import 'package:foodloop/features/orders/presentation/views/review_order_view.dart';
import 'package:foodloop/features/profile/presentation/views/add_address_view.dart';
import 'package:foodloop/features/profile/presentation/views/profile_view.dart';
import 'package:foodloop/features/support/presentation/views/create_ticket_view.dart';
import 'package:foodloop/features/support/presentation/views/ticket_details_view.dart';
import 'package:foodloop/features/store_profile/presentation/views/store_profile_view.dart';

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

      case RoutesNames.addAddressView:
        final address = settings.arguments as AddressModel?;
        return MaterialPageRoute(
          builder: (_) => AddAddressView(address: address),
        );

      case RoutesNames.productDetailsView:
        final product = settings.arguments as ProductModel;
        return MaterialPageRoute(
          builder: (_) => ProductDetailsView(product: product),
        );

      case RoutesNames.searchView:
        return MaterialPageRoute(builder: (_) => const SearchView());

      case RoutesNames.addProductView:
        return MaterialPageRoute(builder: (_) => const AddProductView());

      case RoutesNames.expirationDetailsView:
        final draft = settings.arguments as ProductDraft;
        return MaterialPageRoute(
          builder: (_) => ExpirationDetailsView(draft: draft),
        );

      case RoutesNames.scanningView:
        final scanArgs = settings.arguments as ScanningArgs;
        return MaterialPageRoute(builder: (_) => ScanningView(args: scanArgs));

      case RoutesNames.verificationResultsView:
        final resultsArgs = settings.arguments as VerificationResultsArgs;
        return MaterialPageRoute(
          builder: (_) => VerificationResultsView(args: resultsArgs),
        );

      case RoutesNames.mainNav:
        return MaterialPageRoute(builder: (_) => const MainNavigationView());

      case RoutesNames.createTicketView:
        return MaterialPageRoute(builder: (_) => const CreateTicketView());

      case RoutesNames.ticketDetailsView:
        final ticketId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => TicketDetailsView(ticketId: ticketId),
        );

      case RoutesNames.reviewOrderView:
        final order = settings.arguments as OrderModel;
        return MaterialPageRoute(
          builder: (_) => ReviewOrderView(order: order),
        );

      case RoutesNames.storeProfileView:
        final storeId = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => StoreProfileView(storeId: storeId),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
