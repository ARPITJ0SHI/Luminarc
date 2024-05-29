import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pixel_color_picker/pixel_color_picker.dart';

class PixelColorImage extends StatefulWidget {
  @override
  _PixelColorImageState createState() => _PixelColorImageState();
}

class _PixelColorImageState extends State<PixelColorImage> {
  showBuildContext(context, {Color? backgroundColor,Uint8List? image,onPick}) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        Color tempColor = backgroundColor!;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
          
              title: const Text("Move your finger"),
              content: Column(
                mainAxisSize:  MainAxisSize.min,
                children: [
                  PixelColorPicker(child: Image.memory(image!), onChanged:(color){
                    setState((){
                      tempColor=color;
                    });
                  }
                  ),
                  const SizedBox(height: 10,),
                  Container(
                    width: double.infinity,
                    height: 80,
                    color: tempColor,
                  ),

                ],
              ),
              
              actions: [
                TextButton(onPressed: (){
              Navigator.of(context).pop;
              },
               child: const Text('Cancel')),
                TextButton(onPressed: (){
              onPick(tempColor);
              Navigator.of(context).pop;
              },
               child: const Text('Pick'))
               
               ],
            );
          }
        );
      }
    );
  }
  
  @override
  Widget build(Object context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}