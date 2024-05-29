import 'package:flutter/material.dart';
import 'package:luminarc/Provider/imageProvider.dart';

import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:luminarc/helper/app_Image_picker.dart';
import 'package:luminarc/routes/Routes.dart';

class StartScreen extends StatefulWidget {
  StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  AppImageProvider? appImageProv;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        appImageProv = Provider.of<AppImageProvider>(context, listen: false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/images/landing.jpeg",
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 80),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                     
                      AppImagePicker().pick(
                        source: ImageSource.gallery,
                        onPick: (File? image) {
                          if (image != null) {
                            appImageProv?.changeImageFile(image);
                            Navigator.of(context)
                                .pushReplacementNamed(AppRoutes.home);
                          } else {
                            print("Image not picked");
                          }
                        },
                      );
                    },
                    child: Text("Gallery"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      
                      AppImagePicker().pick(
                        source: ImageSource.camera,
                        onPick: (File? image) {
                          if (image != null) {
                            appImageProv?.changeImageFile(image);
                            print("hellooooooooooooooo");
                            Navigator.of(context)
                                .pushReplacementNamed(AppRoutes.home);
                          } else {
                            print("Image not picked");
                          }
                        },
                      );
                    },
                    child: Text("Camera"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
