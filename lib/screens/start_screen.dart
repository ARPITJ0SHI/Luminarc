import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:luminarc/helper/app_Image_picker.dart';
import 'package:luminarc/routes/Routes.dart';
import 'package:provider/provider.dart';

import '../Provider/App_Image_provider.dart';


class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  late AppImageProvider appimageProvider;
  @override
  void initState() {
     appimageProvider = Provider.of<AppImageProvider>(context,listen:false);

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
              "assets/images/flowerwallpaper.jpg",
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              const Expanded(
                  child: Center(
                child: Text(
                  "Luminarc",
                  style: TextStyle(
                      color: Colors.orange,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 5,
                      wordSpacing: 10),
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
                          AppImagePicker().pick(source:ImageSource.gallery, onPick: (File? image) {
                            // imageProvider.changeImage(image);
                            appimageProvider.changeImage(image!);
                            Navigator.of(context).pushReplacementNamed(AppRoutes.home);

                            
                          },);
                        }, child: const Text("Gallery")),
                    ElevatedButton(
                        onPressed: () {
                          AppImagePicker().pick(source:ImageSource.gallery, onPick: (File? image) {
                            // imageProvider.changeImage(image);
                            appimageProvider.changeImage(image!);
                            Navigator.of(context).pushReplacementNamed(AppRoutes.home);

                          },);
                        }, child: const Text("Camera")),
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
