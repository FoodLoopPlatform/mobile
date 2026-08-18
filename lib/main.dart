import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/api_helper/api_manager.dart';
import 'package:foodloop/core/app_theme/app_theme_manager.dart';
import 'package:foodloop/core/routes_manager/route_generator.dart';
import 'package:foodloop/core/routes_manager/routes_names.dart';
import 'package:foodloop/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:foodloop/features/auth/data/repositories/auth_repository.dart';
import 'package:foodloop/features/auth/presentation/manager/auth_cubit/auth_cubit.dart';
import 'package:foodloop/features/add_product/data/data_sources/category_remote_data_source.dart';
import 'package:foodloop/features/add_product/data/repositories/category_repository.dart';
import 'package:foodloop/features/add_product/presentation/manager/category_cubit/category_cubit.dart';
import 'package:foodloop/features/add_product/data/data_sources/add_product_remote_data_source.dart';
import 'package:foodloop/features/add_product/data/repositories/add_product_repository.dart';
import 'package:foodloop/features/add_product/presentation/manager/add_product_cubit/add_product_cubit.dart';
import 'package:foodloop/features/notifications/data/data_sources/notifications_remote_data_source.dart';
import 'package:foodloop/features/notifications/data/repositories/notifications_repository.dart';
import 'package:foodloop/features/notifications/presentation/manager/notifications_cubit/notifications_cubit.dart';
import 'package:foodloop/features/profile/data/data_sources/profile_remote_data_source.dart';
import 'package:foodloop/features/profile/data/repositories/profile_repository.dart';
import 'package:foodloop/features/profile/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:foodloop/features/localization/presentation/manager/localization_cubit/localization_cubit.dart';
import 'package:foodloop/features/localization/presentation/manager/localization_cubit/localization_state.dart';
import 'package:foodloop/features/cart/data/data_sources/cart_local_data_source.dart';
import 'package:foodloop/features/cart/data/data_sources/order_remote_data_source.dart';
import 'package:foodloop/features/cart/data/repositories/cart_repository.dart';
import 'package:foodloop/features/cart/presentation/manager/cart_cubit/cart_cubit.dart';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:foodloop/core/api_helper/api_constants.dart';
import 'package:foodloop/core/services/push_notification_service.dart';
import 'package:foodloop/core/utils/secure_storage_helper.dart';
import 'package:foodloop/firebase_options.dart';
import 'package:hive_flutter/hive_flutter.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await PushNotificationService.initialize();
  await Hive.initFlutter();
  await Hive.openBox<dynamic>('cart');

  String initialRoute = RoutesNames.welcomeView;
  final refreshToken = await SecureStorageHelper.getRefreshToken();

  if (refreshToken != null) {
    try {
      final dio = Dio();
      final response = await dio.post(
        '${ApiConstants.baseUrl}${ApiConstants.refreshEndpoint}',
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final newAccessToken = response.data['data']['accessToken'];
        final newRefreshToken = response.data['data']['refreshToken'];

        await SecureStorageHelper.saveTokens(newAccessToken, newRefreshToken);

        // If the refresh response includes user data, persist the role.
        // Otherwise the role saved during the last manual login is still valid.
        final userData = response.data['data']['user'];
        if (userData != null) {
          final roles = userData['roles'];
          if (roles is List && roles.isNotEmpty) {
            await SecureStorageHelper.saveUserRole(roles.first as String);
          }
        }

        // Sync FCM token with the backend on auto-login.
        await PushNotificationService.syncDeviceToken(ApiManager());

        initialRoute = RoutesNames.mainNav;
      } else {
        await SecureStorageHelper.clearTokens();
      }
    } catch (e) {
      await SecureStorageHelper.clearTokens();
    }
  }

  final initialLanguage = await SecureStorageHelper.getLanguage() ?? 'ar';

  runApp(FoodloopApp(
    initialRoute: initialRoute, 
    apiManager: ApiManager(),
    initialLanguage: initialLanguage,
  ));
}

class FoodloopApp extends StatelessWidget {
  final String initialRoute;
  final ApiManager apiManager;
  final String initialLanguage;
  const FoodloopApp({
    super.key,
    required this.initialRoute,
    required this.apiManager,
    required this.initialLanguage,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return RepositoryProvider<ApiManager>.value(
          value: apiManager,
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => LocalizationCubit(initialLanguage),
              ),
              BlocProvider(
                create: (_) => CartCubit(
                  CartRepository(
                    CartLocalDataSource(),
                    OrderRemoteDataSource(apiManager),
                  ),
                )..loadCart(),
              ),
              BlocProvider(
                create: (_) => AuthCubit(
                  AuthRepository(AuthRemoteDataSource(apiManager)),
                  CartLocalDataSource(),
                  apiManager,
                ),
              ),
              BlocProvider(
                create: (_) => ProfileCubit(
                  ProfileRepository(ProfileRemoteDataSource(apiManager)),
                ),
              ),
              BlocProvider(
                create: (_) => CategoryCubit(
                  CategoryRepository(CategoryRemoteDataSource(apiManager)),
                ),
              ),
              BlocProvider(
                create: (_) => NotificationsCubit(
                  NotificationsRepository(
                    NotificationsRemoteDataSource(apiManager),
                  ),
                ),
              ),
              BlocProvider(
                create: (_) => AddProductCubit(
                  AddProductRepository(AddProductRemoteDataSource(apiManager)),
                ),
              ),
            ],
            child: BlocBuilder<LocalizationCubit, LocalizationState>(
              builder: (context, state) {
                return MaterialApp(
                  title: 'Foodloop',
                  debugShowCheckedModeBanner: false,
                  locale: Locale(state.locale),
                  localizationsDelegates: const [
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: const [Locale('ar'), Locale('en')],
                  theme: AppThemeManager.mainTheme,
                  navigatorKey: navigatorKey,
                  initialRoute: initialRoute,
                  onGenerateRoute: RouteGenerator.generateRoutes,
                );
              },
            ),
          ),
        );
      },
    );
  }
}
