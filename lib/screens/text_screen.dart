import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:lindi_sticker_widget/lindi_controller.dart';
import 'package:lindi_sticker_widget/lindi_sticker_widget.dart';
import 'package:provider/provider.dart';
import 'package:text_editor/text_editor.dart';
import '../Provider/imageProvider.dart';
import '../helper/fonts.dart';

class TextScreen extends StatefulWidget {
  const TextScreen({Key? key}) : super(key: key);

  @override
  State<TextScreen> createState() => _TextScreenState();
}

class _TextScreenState extends State<TextScreen> {
  late AppImageProvider _imageProvider;
  LindiController controller = LindiController();

  bool showEditor = true;

  @override
  void initState() {
    _imageProvider = Provider.of<AppImageProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            leading: const CloseButton(),
            title: const Text('Text'),
            actions: [
              IconButton(
                onPressed: () async {
                  Uint8List? image = await controller.saveAsUint8List();
                  _imageProvider.changeImage(image!);
                  if (!mounted) return;
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.done),
              ) // _IconButton
            ],
          ),
          body: Center(
            child: Consumer<AppImageProvider>(
              builder: (BuildContext context, value, Widget? child) {
                if (value.currentImage != null) {
                  return LindiStickerWidget(
                    controller: controller,
                    child: Image.memory(value.currentImage!),
                  ); // LindiStickerWidget
                }
                return const Center(
                  child: CircularProgressIndicator(),
                ); // Center
              },
            ), // Consumer
          ),
          bottomNavigationBar: Container(
              width: double.infinity,
            height: 50,
            color: Colors.black,
            child: Center(
              child: TextButton(
                onPressed: () {
                   // controller.addWidget(Text("hello"));
              setState(() {
                showEditor = true;
              });
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, color: Colors.white),
                    Text(
                      "Add Text",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ], 
                ), 
              ), 
            ), 
          ), 
        ), 
                      if (showEditor)
          Scaffold(
            backgroundColor: Colors.black87.withOpacity(0.75),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: TextEditor(
                  fonts: Fonts().list(),
                  textStyle: TextStyle(color: Colors.white),
                  onEditCompleted: (style, align, text) {
                    setState(() {
                      showEditor = false;
                      if (text.isNotEmpty) {
                          controller.addWidget(Text(
                          text,
                          textAlign: align,
                          style: style,
                        ));
                      }
                    });
                  },
                ),
              ),
            ),
          )
      ],
    );
  }
}
