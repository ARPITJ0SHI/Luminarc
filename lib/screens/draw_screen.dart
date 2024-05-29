import 'dart:typed_data';
import 'package:luminarc/helper/app_color_picker.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:luminarc/Provider/imageProvider.dart';
import 'package:painter/painter.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

import '../helper/pixel_color_image.dart';

class DrawScreen extends StatefulWidget {
  const DrawScreen({Key? key}) : super(key: key);

  @override
  _DrawScreenState createState() => _DrawScreenState();
}

class _DrawScreenState extends State<DrawScreen> {
  late AppImageProvider _imageProvider;
  ScreenshotController screenshotController = ScreenshotController();
  PainterController _controller = PainterController();
  Uint8List? currentImage;


  @override
  void initState() {
    super.initState();
    _imageProvider = Provider.of<AppImageProvider>(context, listen: false);
  }

   PainterController _newController() {
    PainterController controller = new PainterController();
    controller.thickness = 5.0;
    controller.backgroundColor = Colors.transparent;
    return controller;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        title: const Text('Draw'),
        actions: [
          IconButton(
            onPressed: () async {
              Uint8List? bytes = await screenshotController.capture();
              _imageProvider.changeImage(bytes!);
              if (mounted) return;
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.done),
          ), 
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Consumer<AppImageProvider>(
              builder: (BuildContext context, value, Widget? child) {
                if (value.currentImage == null) {
                  currentImage = value.currentImage!;
                  return Screenshot(
                    controller: screenshotController,
                    child: Stack(
                      children: [
                        Image.memory(value.currentImage!),
                        Positioned.fill(
                          child: Painter(_controller))
                      ],
                    ),
                  ); 
                }
                return const Center(
                  child: CircularProgressIndicator(),
                ); 
              }, 
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 20,
                        child: Center(
                          child: Icon(
                              Icons.circle,
                              color: Colors.white,
                              size: _controller.thickness +3,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Slider(
                          value: _controller.thickness,
                          onChanged: (value) {
                            setState(() {
                              _controller.thickness = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _bottomBarItem(Icons.undo,
                      onPress: () {
                        _controller.undo();
                      }),
                ) ,
                Expanded(
                  child: _bottomBarItem(Icons.delete,
                      onPress: () {
                        _controller.clear();
                      }),
                ) ,
                Expanded(
                  child: _bottomBarItem(Icons.color_lens_outlined,
                      onPress: () {
                        AppColorPicker().show(context, backgroundColor: _controller.drawColor,
                  onPick: (color) {
                setState() {
                  _controller.drawColor = color;
                }
              });
                      }),
                ) ,
                Expanded(
                  child: _bottomBarItem(Icons.colorize,
                      onPress: () {
                         PixelColorImage().show(context,
                  backgroundColor: _controller.drawColor,
                  image: currentImage, onPick: (color) {
                setState(() {
                  _controller.drawColor = color;
                });
              });
                      }),
                ) ,
                Expanded(
                  child: _bottomBarItem(Icons.edit,
                      onPress: () {
                        _controller.eraseMode = true;
                      }),
                ) ,
                Expanded(
                  child: RotatedBox(
                    quarterTurns: _controller.eraseMode ? 2 : 0,
                    child: _bottomBarItem(Icons.create, onPress: () {
                      setState(() {
                        _controller.eraseMode = !_controller.eraseMode;
                      });
                    }),
                  ), 
                ), 
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget slider(value, onChanged) {
  return Slider(
    label: '${value.toStringAsFixed(2)}',
    value: value,
    max: 20,
    min: 1,
    onChanged: onChanged,
  );
}

Widget _bottomBarItem(IconData icon,{required onPress}) {
  return InkWell(
    onTap: onPress,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color:  Colors.white),
          
        ],
      ),
    ),
  );
}
