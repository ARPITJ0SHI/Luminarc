import 'package:flutter/material.dart';
import 'package:luminarc/Provider/imageProvider.dart';

import 'package:luminarc/routes/routes.dart';
import 'package:luminarc/screens/adjust_screen.dart';
import 'package:luminarc/screens/blur_screen.dart';

import 'package:luminarc/screens/crop_screen.dart';
import 'package:luminarc/screens/draw_screen.dart';
import 'package:luminarc/screens/filter_screen.dart';
import 'package:luminarc/screens/fit_screen.dart';

import 'package:luminarc/screens/homescreen.dart';
import 'package:luminarc/screens/mask_screen.dart';
import 'package:luminarc/screens/start_screen.dart';
import 'package:luminarc/screens/sticker_screen.dart';
import 'package:luminarc/screens/tint_screen.dart';

import 'package:provider/provider.dart';

import 'screens/text_screen.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => AppImageProvider())
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Luminarc',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          sliderTheme:
              const SliderThemeData(showValueIndicator: ShowValueIndicator.always)),
      initialRoute: AppRoutes.startScreen,
      routes: {
        AppRoutes.home: (context) => HomePage(),
        AppRoutes.startScreen: (context) => StartScreen(),
        AppRoutes.crop: (context) => const CropScreen(),
        AppRoutes.filters: (context) => const FilterScreen(),
        AppRoutes.adjust: (context) => const AdjustScreen(),
        AppRoutes.tint: (context) => const TintScreen(),
        AppRoutes.blur : (context) => const BlurScreen(),
        AppRoutes.sticker : (context) => const StickerScreen(),
        AppRoutes.fit: (context) => const FitScreen(),
        AppRoutes.text: (context) => const TextScreen(),
        AppRoutes.draw: (context) => const DrawScreen(),
        AppRoutes.mask: (context) => const MaskScreen()
      },
    );
  }
}
