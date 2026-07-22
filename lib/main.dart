import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodloop/core/app_theme/app_theme_manager.dart';
import 'package:foodloop/core/routes_manager/route_generator.dart';
import 'package:foodloop/core/routes_manager/routes_names.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FoodloopApp());
}

class FoodloopApp extends StatelessWidget {
  const FoodloopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          title: 'Foodloop',
          debugShowCheckedModeBanner: false,
          theme: AppThemeManager.mainTheme,
          initialRoute: RoutesNames.profileView,
          onGenerateRoute: RouteGenerator.generateRoutes,
        );
      },
    );
  }
}
