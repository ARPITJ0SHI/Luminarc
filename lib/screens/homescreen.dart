import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luminarc/helper/cons.dart';

import 'package:luminarc/routes/routes.dart';
import 'package:luminarc/screens/crop_screen.dart';
import 'package:luminarc/screens/start_screen.dart';
import 'package:provider/provider.dart';

import '../Provider/imageProvider.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Constants.appBarColor,
          title: Text(
            "Luminarc",
            style:
                GoogleFonts.poppins(textStyle: TextStyle(color: Colors.white)),
          ),
          centerTitle: true,
          leading: CloseButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(AppRoutes.startScreen);
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: TextButton(
                  onPressed: () {},
                  child: Text('save',
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              color: Constants.primaryTextColor,
                              fontWeight: FontWeight.w700)))),
            )
          ]),
      backgroundColor: Colors.black87,
      body: Center(
        child: Consumer<AppImageProvider>(
          builder: (BuildContext context, value, child) {
            if (value.currentImage != null) {
              return Image.memory(value.currentImage!);
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
      bottomNavigationBar: Container(
        height: 80,
        width: double.infinity,
        color: Colors.black,
        child: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _bottomBarItem(Icons.crop_rotate, 'crop', onPress: () {
                  Navigator.pushNamed(context, AppRoutes.crop);
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _bottomBarItem(IconData icon, String title, {required onPress}) {
  return InkWell(
    onTap: onPress,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Constants.primaryTextColor,
          ),
          const SizedBox(
            height: 3,
          ),
          Text(
            title,
            style: TextStyle(color: Constants.primaryTextColor),
          )
        ],
      ),
    ),
  );
}
