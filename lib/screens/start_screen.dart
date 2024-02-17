import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:luminarc/helper/app_Image_picker.dart';
import 'package:luminarc/routes/Routes.dart';
import 'package:provider/provider.dart';

import '../Provider/App_Image_provider.dart';

class StartScreen extends StatefulWidget {
  StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  late AppImageProvider appimageProvider;
  @override
  void initState() {
    appimageProvider = Provider.of<AppImageProvider>(context, listen: false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            child: Image.asset(
              "assets/images/landing.jpeg",
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              Expanded(
                  child: Center(
                child: Text(
                  "Luminarc",
                  style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                          color: Colors.orange,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4,
                          wordSpacing: 10)),
                ),
              )),
              Expanded(child: Container()),
              Expanded(
                  child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          AppImagePicker().pick(
                            source: ImageSource.gallery,
                            onPick: (File? image) {
                              // imageProvider.changeImage(image);
                              if (image != null) {
                                appimageProvider.changeImage(image!);
                                Navigator.of(context)
                                    .pushReplacementNamed(AppRoutes.home);
                              } else {
                                print("image not picked");
                              }
                            },
                          );
                        },
                        child: Text("Gallery")),
                    ElevatedButton(
                        onPressed: () {
                          AppImagePicker().pick(
                            source: ImageSource.camera,
                            onPick: (File? image) {
                              if (image != Null) {
                                appimageProvider.changeImage(image!);
                                Navigator.of(context)
                                    .pushReplacementNamed(AppRoutes.home);
                              } else {
                                print("image not picked");
                              }
                            },
                          );
                        },
                        child: Text("Camera")),
                  ],
                ),
              ))
            ],
          )
        ],
      ),
    );
  }
}
