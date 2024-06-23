import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:luminarc/Models/tint_model.dart';
import 'package:luminarc/Provider/imageProvider.dart';
import 'package:luminarc/helper/cons.dart';
import 'package:luminarc/helper/tints.dart';

import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class TintScreen extends StatefulWidget {
  const TintScreen({super.key});

  @override
  State<TintScreen> createState() => _TintScreenState();
}

class _TintScreenState extends State<TintScreen> {
  late AppImageProvider appImageProvider;
  ScreenshotController screenshotController = ScreenshotController();
  late List<Tint> tints;
  int index = 0;

  @override
  void initState() {
    super.initState();
    appImageProvider = Provider.of<AppImageProvider>(context, listen: false);
    tints = Tints().list();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        leading: const CloseButton(color: Colors.white),
        title: const Text('Tint',style: TextStyle(color: Colors.white),),
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
                    child: Image.memory(
                      value.currentImage!,
                      fit: BoxFit.cover,
                      colorBlendMode: BlendMode.color,
                      color:
                          tints[index].color.withOpacity(tints[index].opacity),
                    ),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: slider(
                      value: tints[index].opacity,
                      onChanged: (value) {
                        setState(() {
                          tints[index].opacity = value;
                        });
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 60,
        width: double.infinity,
        color: Colors.black,
        child: SafeArea(
          child: Container(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: tints.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  Tint tint = tints[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        this.index = index;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 8),
                      child: CircleAvatar(
                        backgroundColor: this.index == index
                            ? Colors.white
                            : Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: CircleAvatar(
                            backgroundColor: tint.color,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }

  Widget slider({value, onChanged}) {
    return Slider(
        label: '${value.toStringAsFixed(2)}',
        value: value,
        max: 1,
        min: 0,
        onChanged: onChanged);
  }

  Widget _bottomBarItem(
      {IconData? icon, required String title, required VoidCallback onPress}) {
    return InkWell(
      onTap: onPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Constants.primaryTextColor,
              size: 25,
            ),
            const SizedBox(height: 3),
            Text(
              title,
              style: TextStyle(color: Constants.primaryTextColor),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
