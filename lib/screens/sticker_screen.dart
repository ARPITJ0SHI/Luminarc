import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lindi_sticker_widget/lindi_controller.dart';
import 'package:lindi_sticker_widget/lindi_sticker_widget.dart';
import 'package:luminarc/Provider/imageProvider.dart';
import 'package:luminarc/helper/stickers.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class StickerScreen extends StatefulWidget {
  const StickerScreen({super.key});

  @override
  State<StickerScreen> createState() => _StickerScreenState();
}

class _StickerScreenState extends State<StickerScreen> {
  late AppImageProvider appImageProvider;
  ScreenshotController screenshotController = ScreenshotController();
  LindiController controller = LindiController();
  int index = 0;

  @override
  void initState() {
    super.initState();
    appImageProvider = Provider.of<AppImageProvider>(context, listen: false);
    controller.borderColor = Colors.black87;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        leading: const CloseButton(color: Colors.white),
        title: const Text('Sticker',style: TextStyle(color: Colors.white),),
        actions: [
          IconButton(
            onPressed: () async {
              Uint8List? image = await controller.saveAsUint8List();
              appImageProvider.changeImage(image!);
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.done,color: Colors.white),
          ),
        ],
      ),
      body: Container(
        color: Colors.black87,
        child: Stack(
          children: [
            Center(
              child: Consumer<AppImageProvider>(
                builder: (BuildContext context, value, Widget? child) {
                  if (value.currentImage != null) {
                    return LindiStickerWidget(
                        controller: controller,
                        child: Screenshot(
                          controller: screenshotController,
                          child: Image.memory(
                            value.currentImage!,
                            fit: BoxFit.cover,
                          ),
                        ));
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 120,
        color: Colors.black,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                  child: Container(
                color: Colors.black,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: Stickers().list()[index].length,
                  itemBuilder: (BuildContext context, int idx) {
                    String sticker = Stickers().list()[index][idx];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              width: 60,
                              height: 60,
                              child: FittedBox(
                                fit: BoxFit.fill,
                                child: InkWell(
                                  onTap: () {
                                    controller.addWidget(Image.asset(
                                      sticker,
                                      width: 50,
                                    ));
                                  },
                                  child: Image.asset(sticker),
                                ),
                              )),
                        ],
                      ),
                    );
                  },
                ),
              )),
              SingleChildScrollView(
                child: Row(
                  children: [
                    for (int i = 0; i < Stickers().list().length; i++)
                      _bottomBarItem(i, Stickers().list()[i][0], onPress: () {
                        setState(() {
                          index = i;
                        });
                      })
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomBarItem(int idx, String icon,
      {Color? color, required VoidCallback onPress}) {
    return InkWell(
      onTap: onPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                color: index == idx ? Colors.blue : Colors.transparent,
                height: 2,
                width: 38,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(icon, width: 20),
            ),

            // Text( style: TextStyle(color: color ?? Colors.white70)),
          ],
        ),
      ),
    );
  }
}
