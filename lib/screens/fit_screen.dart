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
  const FitScreen({Key? key}) : super(key: key); // Fix the super keyword

  @override
  State<FitScreen> createState() => _FitScreenState();
}

class _FitScreenState extends State<FitScreen> {
  late AppImageProvider appImageProvider;
  ScreenshotController screenshotController = ScreenshotController();
  late Texture currentTexture;
  late List<Texture> textures;

  int x = 1;
  int y = 1;
  int currentItem = 0;
  bool showRatio = true;
  bool showBlur = false;
  bool showColor = false;
  bool showRTexture = false;

  bool showcolorBackground = true;
  bool showImageBackground = false;
  bool showTextrureBackground = false;

  @override
  void initState() {
    textures = Textures().list().cast<Texture>();
    currentTexture = textures[0];
    super.initState();
  }

  void showActiveWidget({bool? r, bool? b, bool? c, bool? t}) {
    showRatio = r ?? false;
    showBlur = b ?? false;
    showColor = c ?? false;
    showRTexture = t ?? false;
    setState(() {});
  }

  void showBackgroundWidget({bool? c, bool? i, bool? t}) {
    showcolorBackground = c ?? false;
    showImageBackground = i ?? false;
    showTextrureBackground = t ?? false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        title: const Text('filters'),
        actions: [
          IconButton(
            onPressed: () async {
              screenshotController.capture().then((Uint8List? image) {}).catchError((onError) {
                print(onError);
              });
              final Uint8List? bytes = await screenshotController.capture();
              appImageProvider.changeImage(bytes!);
              Navigator.of(context).pop();
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
                      Container(
                        color: Colors.white,
                      ),
                      if (showcolorBackground) Container(color: Colors.white),
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
                      if (showTextrureBackground)
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
                    if (showColor) ColorWidget(),
                    if (showRTexture) TextureWidget(),
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
}

Widget _bottomBarItem(IconData icon, String title, {required void Function() onPress}) {
  return InkWell(
    onTap: onPress,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
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
          TextButton(onPressed: () {}, child: Text('1:1')),
          TextButton(onPressed: () {}, child: Text('2:1')),
          TextButton(onPressed: () {}, child: Text('1:2')),
          TextButton(onPressed: () {}, child: Text('4:3')),
          TextButton(onPressed: () {}, child: Text('4:3')),
          TextButton(onPressed: () {}, child: Text('3:4')),
          TextButton(onPressed: () {}, child: Text('16:9')),
          TextButton(onPressed: () {}, child: Text('9:16')),
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
                    });
                  } else {
                    print("Image not picked");
                  }
                },
              );
            },
            icon: Icon(
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
              },
            ),
          ),
        ],
      ),
    ),
  );
}

Widget ColorWidget() {
  return Container(
    color: Colors.black,
    child: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: () {
              // Handle color pick
            },
            icon: Icon(
              Icons.color_lens_outlined,
              color: Colors.blue,
            ),
          ),
          IconButton(
            onPressed: () {
              // Handle pixel color pick
            },
            icon: Icon(
              Icons.colorize,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget TextureWidget() {
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
                        });
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


/*
import 'dart:io';
import 'dart:typed_data';

import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:luminarc/helper/Textures.dart';
import 'package:luminarc/helper/app_image_picker.dart';
import 'package:luminarc/helper/pixel_color_image.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

import '../Provider/imageProvider.dart';
import 'package:luminarc/Models/texture.dart' as t;

class FitScreen extends StatefulWidget {
  const FitScreen({super.key});

  @override
  State<FitScreen> createState() => _FitScreenState();
}

double blur = 0;
Color background = Colors.white;
Uint8List? backgroundImage;
Uint8List? currentImage;

class _FitScreenState extends State<FitScreen> {
  // late Filter currentfilter;
  // late List<Filter> filters;
  late AppImageProvider appImageProvider;
  ScreenshotController screenshotController = ScreenshotController();
   late Texture currentTexture;
  late List<Texture> textures;

  int x = 1;
  int y = 1;
  int currentItem = 0;
  bool showRatio = true;
  bool showBlur = false;
  bool showColor = false;
  bool showRTexture = false;

  bool showcolorBackground = true;
  bool showImageBackground = false;
  bool showTextrureBackground = false;

  @override
  void initSate() {
    textures =Textures().list().cast<Texture>();
    currentTexture =textures[0];
    appImageProvider = Provider.of<AppImageProvider>(context as BuildContext, listen: false);
    super.initState();
  }

  showActiveWidget({r, b, c, t}) {
    showRatio = r != null ? true : false;
    showRatio = b != null ? true : false;
    showRatio = c != null ? true : false;
    showRatio = t != null ? true : false;
    setState(() {});
  }

  showBackgroundWidget({c, i, t}) {
    showcolorBackground = c != null ? true : false;
    showImageBackground = i != null ? true : false;
    showTextrureBackground = t != null ? true : false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const CloseButton(),
          title: const Text('filters'),
          actions: [
            IconButton(
                onPressed: () async {
                  screenshotController
                      .capture()
                      .then((Uint8List? image) {})
                      .catchError((onError) {
                    print(onError);
                  });
                  final Uint8List? bytes = await screenshotController.capture();
                  appImageProvider.changeImage(bytes!);
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.done))
          ],
        ),
        body: Center(
          child: Consumer<AppImageProvider>(
            builder: (BuildContext context, value, child) {
              if (value.currentImage != null) {
                currentImage = value.currentImage!;
                backgroundImage ??= value.currentImage!;
                return AspectRatio(
                  aspectRatio: x / y,
                  child: Screenshot(
                    controller: screenshotController,
                    child: Stack(children: [
                      Container(
                        color: Colors.white,
                      ),
                      if (showcolorBackground)
                        Container(
                          color: Colors.white,
                        ),
                      if (showImageBackground) // isko true is kara hai usne par merko toh false hi accha lag raha hai
                        Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: MemoryImage(backgroundImage!))),
                          child: Center(
                            child: Image.memory(
                              value.currentImage!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ).blurred(colorOpacity: 0, blur: blur),
                      if (showTextrureBackground)
                        Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(currentTexture.path!)
                                  )),
                          child: Center(
                            child: Image.memory(
                              value.currentImage!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ).blurred(colorOpacity: 0, blur: blur)
                    ]),
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
                    if (showRatio) 
                    ratioWidget(),
                    if (showBlur)
                    blurWidget(),
                    if (showColor)
                    ColorWidget(),
                    if (showRTexture)
                    TextureWidget(),
                  ],
                )),
                Row(
                  children: [
                    // Text('dsa',style: TextStyle(color: Colors.white),)
                    Expanded(
                      child: _bottomBarItem(Icons.aspect_ratio, 'Ratio',
                          onPress: () {
                        showActiveWidget(r: true);
                      }),
                    ),
                    Expanded(
                      child: _bottomBarItem(Icons.blur_linear, 'Blur',
                          onPress: () {
                        showBackgroundWidget(i: true);
                        showActiveWidget(b: true);
                      }),
                    ),
                    Expanded(
                      child: _bottomBarItem(Icons.color_lens_outlined, 'Color',
                          onPress: () {
                        showBackgroundWidget(c: true);
                        showActiveWidget(c: true);
                      }),
                    ),
                    Expanded(
                      child:
                          _bottomBarItem(Icons.texture, 'Texture', onPress: () {
                        showBackgroundWidget(t: true);
                        showActiveWidget(t: true);
                      }),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}

Widget _bottomBarItem(IconData icon, String title, {required onPress}) {
  return InkWell(
    onTap: onPress,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          const SizedBox(
            height: 3,
          ),
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
          TextButton(onPressed: () {}, child: Text('1:1')),
          TextButton(onPressed: () {}, child: Text('2:1')),
          TextButton(onPressed: () {}, child: Text('1:2')),
          TextButton(onPressed: () {}, child: Text('4:3')),
          TextButton(onPressed: () {}, child: Text('4:3')),
          TextButton(onPressed: () {}, child: Text('3:4')),
          TextButton(onPressed: () {}, child: Text('16:9')),
          TextButton(onPressed: () {}, child: Text('9:16')),
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
                    backgroundImage = await image.readAsBytes();
                    setState(() {});
                  } else {
                    print("Image not picked");
                  }
                },
              );
            },
            icon: Icon(
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
                setState(() {});
              },
            ),
          ),
        ],
      ),
    ),
  );
}

Widget ColorWidget() {
  return Container(
    color: Colors.black,
    child: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        // crossAxisAlignment: CrossAxisAlignment.center, // -------------------------------
        children: [
          IconButton(
            onPressed: () {
              AppColorPicker().show(context, backgroundColor: background,
                  onPick: (color) {
                setState() {
                  backgroundColor = color;
                }
              });
            },
            icon: Icon(
              Icons.color_lens_outlined,
              color: Colors.blue,
            ),
          ),
          IconButton(
            onPressed: () {
              PixelColorImage().show(context,
                  backgroundColor: background,
                  image: backgroundImage, onPick: (color) {
                setState(() {
                  backgroundColor = color;
                });
              });
            },
            icon: Icon(
              Icons.colorize,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget TextureWidget() {
  return Container(
    color: Colors.black,
    child:  Center(
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
                              height:40,
                              child: FittedBox(
                                fit: BoxFit.fill,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      currentTexture = texture;
                                    });
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
    )
  );
}

 */