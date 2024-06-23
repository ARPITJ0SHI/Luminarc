import 'dart:io';
import 'dart:typed_data';

import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:luminarc/helper/Textures.dart';
import 'package:luminarc/helper/app_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

import '../Provider/imageProvider.dart';
import 'package:luminarc/Models/texture.dart' as t;

class FitScreen extends StatefulWidget {
  const FitScreen({Key? key}) : super(key: key);

  @override
  State<FitScreen> createState() => _FitScreenState();
}

class _FitScreenState extends State<FitScreen> {
  late AppImageProvider appImageProvider;
  ScreenshotController screenshotController = ScreenshotController();
  late t.Texture currentTexture;
  late List<t.Texture> textures;
  Uint8List? backgroundImage;
  double blur = 0.0;

  int x = 1;
  int y = 1;
  int currentItem = 0;
  bool showRatio = true;
  bool showBlur = false;
  bool showColor = false;
  bool showRTexture = false;

  bool showColorBackground = true;
  bool showImageBackground = false;
  bool showTextureBackground = false;

  @override
  void initState() {
    super.initState();
    textures = Textures().list().cast<t.Texture>();
    currentTexture = textures[0];
  }

  void showActiveWidget({bool? r, bool? b, bool? c, bool? t}) {
    setState(() {
      showRatio = r ?? false;
      showBlur = b ?? false;
      showColor = c ?? false;
      showRTexture = t ?? false;
    });
  }

  void showBackgroundWidget({bool? c, bool? i, bool? t}) {
    setState(() {
      showColorBackground = c ?? false;
      showImageBackground = i ?? false;
      showTextureBackground = t ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    appImageProvider = Provider.of<AppImageProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        title: const Text('Fit'),
        actions: [
          IconButton(
            onPressed: () async {
              final Uint8List? bytes = await screenshotController.capture();
              if (bytes != null) {
                appImageProvider.changeImage(bytes);
                Navigator.of(context).pop();
              }
            },
            icon: const Icon(Icons.done),
          )
        ],
      ),
      body: Center(
        child: Consumer<AppImageProvider>(
          builder: (BuildContext context, value, child) {
            if (value.currentImage != null) {
              return AspectRatio(
                aspectRatio: x / y,
                child: Screenshot(
                  controller: screenshotController,
                  child: Stack(
                    children: [
                      Container(color: Colors.white),
                      if (showColorBackground) Container(color: Colors.white),
                      if (showImageBackground)
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: MemoryImage(value.currentImage!),
                            ),
                          ),
                          child: Center(
                            child: Image.memory(
                              value.currentImage!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ).blurred(colorOpacity: 0, blur: blur),
                      if (showTextureBackground)
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(currentTexture.path!),
                            ),
                          ),
                          child: Center(
                            child: Image.memory(
                              value.currentImage!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ).blurred(colorOpacity: 0, blur: blur)
                    ],
                  ),
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
      bottomNavigationBar: Container(
        height: 100,
        width: double.infinity,
        color: Colors.black,
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    if (showRatio) ratioWidget(),
                    if (showBlur) blurWidget(),
                    if (showColor) colorWidget(),
                    if (showRTexture) textureWidget(),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: _bottomBarItem(
                      Icons.aspect_ratio,
                      'Ratio',
                      onPress: () {
                        showActiveWidget(r: true);
                        print('Ratio button pressed');
                      },
                    ),
                  ),
                  Expanded(
                    child: _bottomBarItem(
                      Icons.blur_linear,
                      'Blur',
                      onPress: () {
                        showBackgroundWidget(i: true);
                        showActiveWidget(b: true);
                        print('Blur button pressed');
                      },
                    ),
                  ),
                  Expanded(
                    child: _bottomBarItem(
                      Icons.color_lens_outlined,
                      'Color',
                      onPress: () {
                        showBackgroundWidget(c: true);
                        showActiveWidget(c: true);
                        print('Color button pressed');
                      },
                    ),
                  ),
                  Expanded(
                    child: _bottomBarItem(
                      Icons.texture,
                      'Texture',
                      onPress: () {
                        showBackgroundWidget(t: true);
                        showActiveWidget(t: true);
                        print('Texture button pressed');
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomBarItem(IconData icon, String title, {required void Function() onPress}) {
    return InkWell(
      onTap: onPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(height: 3),
            Text(
              title,
              style: const TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }

  Widget ratioWidget() {
    return Container(
      color: Colors.black,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            TextButton(
              onPressed: () {
                setState(() {
                  x = 1;
                  y = 1;
                });
                print('1:1 ratio selected');
              },
              child: const Text('1:1', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  x = 2;
                  y = 1;
                });
                print('2:1 ratio selected');
              },
              child: const Text('2:1', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  x = 1;
                  y = 2;
                });
                print('1:2 ratio selected');
              },
              child: const Text('1:2', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  x = 4;
                  y = 3;
                });
                print('4:3 ratio selected');
              },
              child: const Text('4:3', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  x = 3;
                  y = 4;
                });
                print('3:4 ratio selected');
              },
              child: const Text('3:4', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  x = 16;
                  y = 9;
                });
                print('16:9 ratio selected');
              },
              child: const Text('16:9', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  x = 9;
                  y = 16;
                });
                print('9:16 ratio selected');
              },
              child: const Text('9:16', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget blurWidget() {
    return Container(
      color: Colors.black,
      child: Center(
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                AppImagePicker().pick(
                  source: ImageSource.gallery,
                  onPick: (File? image) async {
                    if (image != null) {
                      final bytes = await image.readAsBytes();
                      setState(() {
                        backgroundImage = bytes;
                        showImageBackground = true;
                        showTextureBackground = false;
                        showColorBackground = false;
                      });
                      print('Image selected for blur background');
                    } else {
                      print("Image not picked");
                    }
                  },
                );
              },
              icon: const Icon(
                Icons.photo_library_outlined,
                color: Colors.white,
              ),
            ),
            Expanded(
              child: Slider(
                label: "${blur.toStringAsFixed(2)}",
                value: blur,
                min: 0,
                max: 100,
                onChanged: (value) {
                  setState(() {
                    blur = value;
                  });
                  print('Blur value changed: $value');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget colorWidget() {
    return Container(
      color: Colors.black,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                // Color pick logic here
                print('Color pick button pressed');
              },
              icon: const Icon(
                Icons.color_lens_outlined,
                color: Colors.blue,
              ),
            ),
            IconButton(
              onPressed: () {
                // Handle pixel color pick
                print('Pixel color pick button pressed');
              },
              icon: const Icon(
                Icons.colorize,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget textureWidget() {
    return Container(
      color: Colors.black,
      child: Center(
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: textures.length,
          itemBuilder: (BuildContext context, int index) {
            t.Texture texture = textures[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            currentTexture = texture;
                            showTextureBackground = true;
                            showImageBackground = false;
                            showColorBackground = false;
                          });
                          print('Texture selected: ${texture.path}');
                        },
                        child: Image.asset(texture.path!),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
