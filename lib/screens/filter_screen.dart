import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Provider/app_image_provider.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        title: const Text('filters'),
        actions: [
          IconButton(onPressed:() async {
          }, icon: const Icon(Icons.done))
        ],
      ),
       body: Center(
        child: Consumer<AppImageProvider>(
          builder: (BuildContext context, value, child) {
            if (value.currentImage != null) { 
              return ColorFiltered(
                colorFilter: ColorFilter.mode(Colors.red, BlendMode.overlay),
                child: Image.memory(value.currentImage!,fit: BoxFit.cover,)); // memory ki jagah assests banana hai


            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}