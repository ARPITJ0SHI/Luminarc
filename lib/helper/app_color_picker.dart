import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class AppColorPicker extends StatefulWidget {
  @override
  _AppColorPickerState createState() => _AppColorPickerState();

  void show(BuildContext context, {Color? backgroundColor, Function(Color)? onPick}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Color pickerColor = backgroundColor ?? Colors.transparent;
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickerColor,
              onColorChanged: (color) {
                pickerColor = color;
              },
              showLabel: true,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Got it'),
              onPressed: () {
                Navigator.of(context).pop();
                if (onPick != null) {
                  onPick(pickerColor);
                }
              },
            ),
          ],
        );
      },
    );
  }
}

class _AppColorPickerState extends State<AppColorPicker> {
  @override
  Widget build(BuildContext context) {
    return Container(); // Dummy build method
  }
}
