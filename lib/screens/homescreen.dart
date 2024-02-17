import 'package:flutter/material.dart';
import 'package:luminarc/Provider/App_Image_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Consumer<AppImageProvider>(builder: (BuildContext context, value, child){
          if(value.currentImage!=null){
            return Image.memory(value.currentImage!);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),)
    );
  }
}