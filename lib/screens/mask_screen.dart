import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:luminarc/Widgets/gesture_dectector_widget.dart';
import 'package:luminarc/helper/shapes.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:widget_mask/widget_mask.dart';

import '../Provider/imageProvider.dart';

class MaskScreen extends StatefulWidget {
  const MaskScreen({super.key});

  @override
  State<MaskScreen> createState() => _MaskScreenState();
}

class _MaskScreenState extends State<MaskScreen> {

  late AppImageProvider _imageProvider;
  ScreenshotController screenshotController = ScreenshotController();
  Uint8List? currentImage;
  IconData iconData =Shapes().list()[0];
  BlendMode blendmode = BlendMode.dstIn;
  double opacity = 1;
   @override
  void initState() {
    _imageProvider = Provider.of<AppImageProvider>(context, listen: false);
    super.initState();
  }
  // late PainterController _controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(    
        backgroundColor: Colors.black87,
      leading: const CloseButton(color: Colors.white),
        title: const Text('Mask',style: TextStyle(color: Colors.white),),
        actions: [
          IconButton(
            onPressed: () async {
              Uint8List? bytes = await screenshotController.capture();
              _imageProvider.changeImage(bytes!);
              if (!mounted) return;
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.done,color: Colors.white),
          ),
        ],
      ),
      body:  Container(
        color: Colors.black87,
        child: Center(
              child: Consumer<AppImageProvider>(
                builder: (BuildContext context, value, Widget? child) {
                  if (value.currentImage != null) {
                    currentImage = value.currentImage!;
                    return Screenshot(
                      controller: screenshotController,
                      child: WidgetMask(
                        childSaveLayer: true,
                        blendMode:blendmode,
                        mask:Stack(
                        children: [
                          Container(
                            color: Colors.black.withOpacity(0.4),
                          ), 
                          GestureDetectorWidget (child: Icon(iconData, size: 250,color: Colors.white.withOpacity(opacity),))
                        ],
                      ),
                    child: Image.memory(value.currentImage!))
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
      ),

           bottomNavigationBar: Container(
        width: double.infinity,
        height: 100,
        color: Colors.black,
        child: SafeArea(
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    TextButton(onPressed: (){setState(() {blendmode = BlendMode.dstIn;});}, child: const Text('dstIn',style: TextStyle(color: Colors.white),)),
                    TextButton(onPressed: (){setState(() {blendmode = BlendMode.overlay;});}, child: const Text('Overlay',style: TextStyle(color: Colors.white),)),
                    TextButton(onPressed: (){setState(() {opacity=0.7;blendmode = BlendMode.screen;});}, child: const Text('screen',style: TextStyle(color: Colors.white),)),
                    TextButton(onPressed: (){setState(() {blendmode = BlendMode.saturation;});}, child: const Text('Saturation',style: TextStyle(color: Colors.white),)),
                    TextButton(onPressed: (){setState(() {blendmode = BlendMode.multiply;});}, child: const Text('Multiply',style: TextStyle(color: Colors.white),)),
                    TextButton(onPressed: (){setState(() {blendmode = BlendMode.difference;});}, child: const Text('Difference',style: TextStyle(color: Colors.white),)),
                    TextButton(onPressed: (){setState(() {blendmode = BlendMode.darken;});}, child: const Text('Darken',style: TextStyle(color: Colors.white),)),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      for(int i = 0; i < Shapes().list().length; i++)
                        _bottomBarItem(
                          Shapes().list()[i],
                          onPress: () {
                            setState(() {
                              opacity=1;
                              iconData =Shapes().list()[i];
                            });
                          }
                        )
                    ],
                  ), 
                ),
              ), 
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomBarItem(IconData icon, {required onPress}) {
  return InkWell(
    onTap: onPress,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
         
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(icon,size: 30,color: Colors.white
            ,),
          ), 
        ],
      ),
    ),
  ); 
}
}