import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luminarc/Provider/imageProvider.dart';
import 'package:luminarc/helper/cons.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class BlurScreen extends StatefulWidget {
  const BlurScreen({super.key});

  @override
  State<BlurScreen> createState() => _BlurScreenState();
}

class _BlurScreenState extends State<BlurScreen> {
  late AppImageProvider appImageProvider;
  ScreenshotController screenshotController = ScreenshotController();

  double sigmaX = 0.1;
  double sigmaY = 0.1;
  TileMode tileMode = TileMode.decal;

  @override
  void initState() {
    super.initState();
    appImageProvider = Provider.of<AppImageProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        leading: const CloseButton(color: Colors.white,),
        title: const Text('Blur',style: TextStyle(color: Colors.white),),
        actions: [
          IconButton(
            onPressed: () async {
              final Uint8List? bytes = await screenshotController.capture();
              appImageProvider.changeImage(bytes!);
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.done,color: Colors.white),
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Consumer<AppImageProvider>(
              builder: (BuildContext context, value, child) {
                if (value.currentImage != null) {
                  return Screenshot(
                    controller: screenshotController,
                    child: ImageFiltered(
                      imageFilter: ImageFilter.blur(
                          sigmaX: sigmaX, sigmaY: sigmaY, tileMode: tileMode),
                      child: Image.memory(
                        value.currentImage!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text("SigmaX:",
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(color: Colors.white))),
                        Expanded(
                          child: slider(
                              value: sigmaX,
                              onChanged: (value) {
                                setState(() {
                                  sigmaX = value;
                                });
                              }),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("SigmaY:",
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(color: Colors.white))),
                        Expanded(
                          child: slider(
                              value: sigmaY,
                              onChanged: (value) {
                                setState(() {
                                  sigmaY = value;
                                });
                              }),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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
                _bottomBarItem("Decal",
                    color: tileMode == TileMode.decal ? Colors.blue : null,
                    onPress: () {
                  setState(() {
                    tileMode = TileMode.decal;
                  });
                }),
                _bottomBarItem("Clamp",
                    color: tileMode == TileMode.clamp ? Colors.blue : null,
                    onPress: () {
                  setState(() {
                    tileMode = TileMode.clamp;
                  });
                }),
                _bottomBarItem("Mirror",
                    color: tileMode == TileMode.mirror ? Colors.blue : null,
                    onPress: () {
                  setState(() {
                    tileMode = TileMode.mirror;
                  });
                }),
                _bottomBarItem("Repeated",
                    color: tileMode == TileMode.repeated ? Colors.blue : null,
                    onPress: () {
                  setState(() {
                    tileMode = TileMode.repeated;
                  });
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget slider({value, onChanged}) {
    return Slider(
        label: '${value.toStringAsFixed(2)}',
        value: value,
        max: 10,
        min: 0.1,
        onChanged: onChanged);
  }

  Widget _bottomBarItem(String title,
      {Color? color, required VoidCallback onPress}) {
    return InkWell(
      onTap: onPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Text(
          title,
          style: TextStyle(
            color: color ?? Colors.white70,
          ),
        ),
      ),
    );
  }
}
