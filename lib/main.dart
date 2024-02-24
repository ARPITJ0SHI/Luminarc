import 'package:flutter/material.dart';
import 'package:luminarc/Provider/App_Image_provider.dart';
import 'package:luminarc/screens/filter_screen.dart';

import 'package:luminarc/screens/homescreen.dart';
import 'package:luminarc/screens/start_screen.dart';

import 'package:provider/provider.dart';

import 'routes/Routes.dart';
import 'screens/crop_screen.dart';

void main() {
  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AppImageProvider())],
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Luminarc',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.home,
      routes: {
        AppRoutes.home: (context) => HomePage(),
        AppRoutes.startScreen: (context) => StartScreen(),
        AppRoutes.crop: (context) => CropScreen(),
        // AppRoutes.filters: (context) => FilterScreen(),
      },
    );
  }
}
