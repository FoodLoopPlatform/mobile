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

import 'package:dio/dio.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:foodloop/core/api_helper/api_constants.dart';
import 'package:foodloop/core/utils/secure_storage_helper.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
        initialRoute = RoutesNames.mainNav;
      } else {
        await SecureStorageHelper.clearTokens();
      }
    } catch (e) {
      await SecureStorageHelper.clearTokens();
    }
  }

  runApp(FoodloopApp(initialRoute: initialRoute));
}

class FoodloopApp extends StatelessWidget {
  final String initialRoute;
  const FoodloopApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) =>
                  AuthCubit(AuthRepository(AuthRemoteDataSource(ApiManager()))),
            ),
          ],
          child: MaterialApp(
            title: 'Foodloop',
            debugShowCheckedModeBanner: false,
            locale: const Locale('ar'),
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
          ),
        );
      },
    );
  }
}
