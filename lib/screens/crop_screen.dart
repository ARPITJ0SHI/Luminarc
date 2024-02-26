import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:crop_image/crop_image.dart';
import 'package:flutter/material.dart';
import 'package:luminarc/Provider/imageProvider.dart';
import 'package:luminarc/helper/cons.dart';
import 'package:provider/provider.dart';

class CropScreen extends StatefulWidget {
  const CropScreen({super.key});

  @override
  State<CropScreen> createState() => _CropScreenState();
}

class _CropScreenState extends State<CropScreen> {
  late CropController cropController;
  late AppImageProvider appImageProvider;

  @override
  void initState() {
    super.initState();
    cropController = CropController(
      aspectRatio: 1.0,
      defaultCrop: const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9),
    );
    appImageProvider = Provider.of<AppImageProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        title: const Text('Crop'),
        actions: [
          IconButton(
            onPressed: _cropAndSaveImage,
            icon: const Icon(Icons.done),
          ),
        ],
      ),
      body: Container(
        color: Colors.black87,
        child: Center(
          child: Consumer<AppImageProvider>(
            builder: (BuildContext context, provider, child) {
              if (provider.originalImage != null) {
                return CropImage(
                  controller: cropController,
                  image:
                      Image.memory(provider.originalImage!, fit: BoxFit.cover),
                  // Rest of your CropImage properties,
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Future<void> _cropAndSaveImage() async {
    try {
      final ui.Image bitmap = await cropController.croppedBitmap();
      final ByteData? data =
          await bitmap.toByteData(format: ImageByteFormat.png);
      if (data != null) {
        final Uint8List bytes = data.buffer.asUint8List();
        appImageProvider.changeImage(bytes);
        Navigator.of(context).pop();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to crop image: $e')),
      );
    }
  }

  Widget _buildBottomBar() {
    return Container(
      height: 80,
      color: Constants.appBarColor,
      child: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _bottomBarItem(
                icon: Icons.rotate_90_degrees_ccw_outlined,
                title: 'Rotate Left',
                onPress: () => cropController.rotateLeft(),
              ),
              _bottomBarItem(
                icon: Icons.rotate_90_degrees_cw_outlined,
                title: 'Rotate Right',
                onPress: () => cropController.rotateRight(),
              ),
              _bottomBarItem(
                  title: "free",
                  onPress: () {
                    cropController.aspectRatio = null;
                    cropController.crop =
                        const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
                  }),
              _bottomBarItem(
                  title: "1:1",
                  onPress: () {
                    cropController.aspectRatio = 1;
                    cropController.crop =
                        const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
                  }),
              _bottomBarItem(
                  title: "2:1",
                  onPress: () {
                    cropController.aspectRatio = 2.0;
                    cropController.crop =
                        const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
                  }),
              _bottomBarItem(
                  title: "1:2",
                  onPress: () {
                    cropController.aspectRatio = 1.0 / 2.0;
                    cropController.crop =
                        const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
                  }),
              _bottomBarItem(
                  title: "4:3",
                  onPress: () {
                    cropController.aspectRatio = 4.0 / 3.0;
                    cropController.crop =
                        const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
                  }),
              _bottomBarItem(
                  title: "3:4",
                  onPress: () {
                    cropController.aspectRatio = 3.0 / 4.0;
                    cropController.crop =
                        const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
                  }),
              _bottomBarItem(
                  title: "16:9",
                  onPress: () {
                    cropController.aspectRatio = 16.0 / 9.0;
                    cropController.crop =
                        const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
                  }),
            ],
          ),
        ),
      ),
    );
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
