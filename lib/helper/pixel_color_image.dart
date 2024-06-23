import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pixel_color_picker/pixel_color_picker.dart';

class PixelColorImage extends StatefulWidget {
  @override
  _PixelColorImageState createState() => _PixelColorImageState();

  void show(BuildContext context, {Color? backgroundColor, Uint8List? image, Function(Color)? onPick}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Color tempColor = backgroundColor ?? Colors.transparent;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Move your finger"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PixelColorPicker(
                    child: image != null ? Image.memory(image) : Container(),
                    onChanged: (color) {
                      setState(() {
                        tempColor = color;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    height: 80,
                    color: tempColor,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if (onPick != null) {
                      onPick(tempColor);
                    }
                    Navigator.of(context).pop();
                  },
                  child: const Text('Pick'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _PixelColorImageState extends State<PixelColorImage> {
  @override
  Widget build(BuildContext context) {
    return Container(); // Dummy build method
  }
}
