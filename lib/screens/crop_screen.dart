import 'dart:typed_data';
import 'dart:ui'as ui;
import 'dart:ui';

import 'package:crop_image/crop_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/app_image_provider.dart';

class CropScreen extends StatefulWidget {
  const CropScreen({super.key});

  @override
  State<CropScreen> createState() => _CropScreenState();
}

class _CropScreenState extends State<CropScreen> {
  
  late CropController cropController = CropController(
    aspectRatio: 1,
  defaultCrop: const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9),
  );
  late AppImageProvider appimageProvider;

  @override
  void initState() {
    appimageProvider = Provider.of<AppImageProvider>(context, listen: false);
        super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        title: const Text('Crop'),
        actions: [
          IconButton(onPressed:() async {
                ui.Image bitmap = await cropController.croppedBitmap();
            //  final image = await cropController.croppedImage();
            ByteData? data = await bitmap.toByteData(format: ImageByteFormat.png);
            Uint8List bytes = data!.buffer.asUint8List();
            // File file.writeAsBytes(bytes, flush);
             appimageProvider.changeImage(bytes);


            if(!mounted) return;
             Navigator.of(context).pop();

          }, icon: const Icon(Icons.done))
        ],
      ),
       body: Center(
        child: Consumer<AppImageProvider>(
          builder: (BuildContext context, value, child) {
            if (value.currentImage != null) {
              return CropImage(
                controller: cropController,
                image: Image.memory(value.currentImage!,fit: BoxFit.cover,), // memory ki jagah assests banana hai

                paddingSize: 25,
                alwaysMove: true,
                // gridColor: Colors.white,
                // gridInnerColor: Colors.white,
                // gridCornerColor: Colors.white,
                // gridCornerSize: 50,
                // gridThinWidth: 3,
                // gridThickWidth: 6,
                // scrimColor: Colors.grey.withOpacity(0.5),
                alwaysShowThirdLines: true,
                // onCrop: (rect) => print(rect),
                // minimumImageSize: 50,
                // maximumImageSize: 2000
                );


            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
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
                _bottomBarCroptem(child: const Icon(Icons.rotate_90_degrees_ccw_outlined,color: Colors.white,), onPress: (){cropController.rotateLeft();}),

                _bottomBarCroptem(child: const Icon(Icons.rotate_90_degrees_cw_outlined,color: Colors.white,), onPress: (){cropController.rotateRight();}),

                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(color: Colors.white,height: 20,width: 1,),
                ),
                _bottomBarCroptem(child:const Text('free',style: TextStyle(color: Colors.white,)), onPress: (){cropController.aspectRatio=null;
                                  cropController.crop = const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);}),
                _bottomBarCroptem(child:const Text('1:1',style: TextStyle(color: Colors.white,)), onPress: (){cropController.aspectRatio=1;
                                  cropController.crop = const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);}),
                _bottomBarCroptem(child:const Text('2:1',style: TextStyle(color: Colors.white,)), onPress: (){cropController.aspectRatio=2.0;
                                  cropController.crop = const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);}),
                _bottomBarCroptem(child:const Text('1:2',style: TextStyle(color: Colors.white,)), onPress: (){cropController.aspectRatio=-1.0/2.0;
                                  cropController.crop = const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);}),
                _bottomBarCroptem(child:const Text('4:3',style: TextStyle(color: Colors.white,)), onPress: (){cropController.aspectRatio=4.0/3.0;
                                  cropController.crop = const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);}),
                _bottomBarCroptem(child:const Text('3:4',style: TextStyle(color: Colors.white,)), onPress: (){cropController.aspectRatio=3.0/4.0;
                                  cropController.crop = const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);}),
                _bottomBarCroptem(child:const Text('16:9',style: TextStyle(color: Colors.white,)), onPress: (){cropController.aspectRatio=16.0/9.0;
                                  cropController.crop = const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


Widget _bottomBarCroptem({required child, required onPress}) {
  return InkWell(
    onTap: onPress,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Center(
        child: child,
      )
    ),
  );
}