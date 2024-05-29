import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerDialog extends StatefulWidget {
  @override
  _ColorPickerDialogState createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  Color? currentColor; // Define currentColor variable
  Color? pickerColor; // Define pickerColor variable

  void show(BuildContext context, {Color? backgroundColor, onPick}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        pickerColor = backgroundColor; // Assign backgroundColor to pickerColor
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: backgroundColor ?? Colors.transparent, // Use backgroundColor if provided, else use transparent
              onColorChanged: (color) {
                setState(() {
                  pickerColor = color;
                });
              },
              showLabel: true, // Show color value labels
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Got it'),
              onPressed: () {
                setState(() {
                  currentColor = pickerColor;
                });
                Navigator.of(context).pop();
                if (onPick != null) {
                  onPick(currentColor); // Call onPick callback with selected color
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is not used in this example. You can remove it.
    throw UnimplementedError();
  }
}
