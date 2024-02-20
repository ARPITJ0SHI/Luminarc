import 'package:flutter/material.dart';
import 'package:luminarc/Provider/App_Image_provider.dart';
import 'package:luminarc/routes/routes.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.black,
          title: Text("Luminar"),
          centerTitle: true,
          leading: CloseButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(AppRoutes.home);
            },
          ),
          actions: [TextButton(onPressed: () {}, child: Text('save'))]),
      backgroundColor: Colors.black,
      body: Center(
        child: Consumer<AppImageProvider>(
          builder: (BuildContext context, value, child) {
            if (value.currentImage != null) {
              return Image.memory(value.currentImage!);
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
                // Text('dsa',style: TextStyle(color: Colors.white),)
                _bottomBarItem(Icons.crop_rotate, 'crop', onPress: () {})
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _bottomBarItem(IconData icon, String title, {required onPress}) {
  return InkWell(
    onTap: onPress,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          const SizedBox(
            height: 3,
          ),
          Text(
            title,
            style: const TextStyle(color: Colors.white),
          )
        ],
      ),
    ),
  );
}
