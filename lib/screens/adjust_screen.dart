import 'dart:typed_data';
import 'package:colorfilter_generator/addons.dart';
import 'package:colorfilter_generator/colorfilter_generator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luminarc/Provider/imageProvider.dart';
import 'package:luminarc/helper/cons.dart';
import 'package:luminarc/routes/routes.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class AdjustScreen extends StatefulWidget {
  const AdjustScreen({super.key});

  @override
  State<AdjustScreen> createState() => _AdjustScreenState();
}

class _AdjustScreenState extends State<AdjustScreen> {
  late AppImageProvider appImageProvider;
  ScreenshotController screenshotController = ScreenshotController();
  late ColorFilterGenerator adj;
  double brightness = 0;
  double contrast = 0;
  double saturation = 0;
  double hue = 0;
  double sepia = 0;
  Map<String, bool> showFilters = {
    'brightness': false,
    'contrast': false,
    'saturation': false,
    'hue': false,
    'sepia': false,
  };

  @override
  void initState() {
    super.initState();
    appImageProvider = Provider.of<AppImageProvider>(context, listen: false);
    _updateAdjustments();
  }

  void _updateAdjustments() {
    adj = ColorFilterGenerator(name: 'Adjust', filters: [
      ColorFilterAddons.brightness(brightness),
      ColorFilterAddons.contrast(contrast),
      ColorFilterAddons.saturation(saturation),
      ColorFilterAddons.hue(hue),
      ColorFilterAddons.sepia(sepia),
    ]);
  }

  void _adjust({double? b, double? c, double? s, double? h, double? se}) {
    setState(() {
      brightness = b ?? brightness;
      contrast = c ?? contrast;
      saturation = s ?? saturation;
      hue = h ?? hue;
      sepia = se ?? sepia;
      _updateAdjustments();
    });
  }

  void _toggleFilter(String filter) {
    setState(() {
      showFilters.keys.forEach((key) => showFilters[key] = false);

      showFilters[filter] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: const CloseButton(),
        title: const Text('Adjust'),
        actions: [
          IconButton(
            onPressed: () async {
              final Uint8List? bytes = await screenshotController.capture();
              appImageProvider.changeImage(bytes!);
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
              builder: (BuildContext context, value, child) {
                if (value.currentImage != null) {
                  return Screenshot(
                    controller: screenshotController,
                    child: ColorFiltered(
                      colorFilter: ColorFilter.matrix(adj.matrix),
                      child: Image.memory(
                        value.currentImage!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildSlider('brightness', brightness,
                          (value) => _adjust(b: value)),
                      _buildSlider(
                          'contrast', contrast, (value) => _adjust(c: value)),
                      _buildSlider('saturation', saturation,
                          (value) => _adjust(s: value)),
                      _buildSlider('hue', hue, (value) => _adjust(h: value)),
                      _buildSlider(
                          'sepia', sepia, (value) => _adjust(se: value)),
                    ],
                  ),
                ),
                TextButton(
                  child: Text(
                    "Reset",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  onPressed: () => _adjust(b: 0, c: 0, s: 0, h: 0, se: 0),
                ),
              ],
            ),
          ),
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
              children: [
                _bottomBarItem(Icons.brightness_4, 'Brightness',
                    onPress: () => _toggleFilter('brightness')),
                _bottomBarItem(Icons.contrast, 'Contrast',
                    onPress: () => _toggleFilter('contrast')),
                _bottomBarItem(Icons.water_drop, 'Saturation',
                    onPress: () => _toggleFilter('saturation')),
                _bottomBarItem(Icons.filter_tilt_shift, 'Hue',
                    onPress: () => _toggleFilter('hue')),
                _bottomBarItem(Icons.motion_photos_on, 'Sepia',
                    onPress: () => _toggleFilter('sepia')),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomBarItem(IconData icon, String title,
      {required VoidCallback onPress}) {
    return InkWell(
      onTap: onPress,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                color: showFilters[title.toLowerCase()] == true
                    ? Colors.blue
                    : Constants.primaryTextColor),
            const SizedBox(height: 3),
            Text(title,
                style: TextStyle(
                    color: showFilters[title.toLowerCase()] == true
                        ? Colors.blue
                        : Constants.primaryTextColor)),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider(
      String filter, double value, ValueChanged<double> onChanged) {
    return Visibility(
      visible: showFilters[filter] == true,
      child: Slider(
        label: "${value.toStringAsFixed(2)}",
        value: value,
        min: -0.9,
        max: 1,
        onChanged: onChanged,
      ),
    );
  }
}
