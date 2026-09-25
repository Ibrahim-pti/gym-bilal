import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gym_base/core/theme/app_theme.dart';
import 'package:gym_base/features/splash/presentation/screens/splash_screen.dart';

import 'package:gym_base/core/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const GymBaseApp());
}

class GymBaseApp extends StatelessWidget {
  const GymBaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gym Base',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: const SplashScreen(),
    );
  }
}
