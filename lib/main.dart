import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_listing/core/config/env_config.dart';
import 'package:photo_listing/core/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize environment configuration
  EnvConfig.init(
    env: Environment.dev,
    apiKey: const String.fromEnvironment('API_KEY', defaultValue: 'dev_key'),
  );

  runApp(
    const ProviderScope(
      child: PhotoListingApp(),
    ),
  );
}

class PhotoListingApp extends StatelessWidget {
  const PhotoListingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'PhotoListing',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          debugShowCheckedModeBanner: false,
          home: const Scaffold(
            body: Center(
              child: Text('PhotoListing App'),
            ),
          ),
        );
      },
    );
  }
}
