import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:luminarc/Provider/imageProvider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

import '../Models/filters.dart';
import '../helper/cons.dart';
import '../helper/filters.dart';
import '../routes/routes.dart';



class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {

  late  List currentfilter;
  late List<Filter> filters;
  late AppImageProvider appImageProvider;
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState(){
    filters=Filters().list();
    currentfilter = filters[0] as List;
     appImageProvider = Provider.of<AppImageProvider>(context, listen: false);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        title: const Text('filters'),
        actions: [
          IconButton(onPressed:() async {
            screenshotController.capture().then((Uint8List? image) {
                
                   }).catchError((onError) {
    print(onError);
});
        final Uint8List? bytes = await screenshotController.capture();
        appImageProvider.changeImage(bytes!);
        Navigator.of(context).pop();
          }, icon: const Icon(Icons.done))
        ],
      ),
       body: Center(
        child: Consumer<AppImageProvider>(
          builder: (BuildContext context, value, child) {
            if (value.currentImage != null) { 
              return Screenshot(
                controller: screenshotController,
                child: ColorFiltered(
                  colorFilter: ColorFilter.matrix(currentfilter[0].matrix),
                  child: Image.memory(value.currentImage!,fit: BoxFit.cover,)),
              ); // memory ki jagah assests banana hai
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
      bottomNavigationBar: Container(
        height: 120,
        width: double.infinity,
        color: Colors.black,
        child: SafeArea(
          child:Consumer<AppImageProvider>(
           builder: (BuildContext context, value, child) {
            return ListView.builder(
              itemBuilder: (BuildContext context , int index){
                Filter filter =filters[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: InkWell(
                            onTap: (){
                              setState(() {
                                currentfilter= [filter];
                              });
                            },
                          child: ColorFiltered(colorFilter: ColorFilter.matrix(filter.matrix),
                          child: Image.memory(value.currentImage!),),
                          ),
                        )
                      ),
                      const SizedBox(height: 5,),
                      Text(filter.filterName)
                    ],
                  ),
                );
              },
          );}
          )
        )
          )
      );
  }
}

Widget _bottomBarItemf({required List currentfilter, required VoidCallback onPress}) {
  return Consumer<AppImageProvider>(
    builder: (BuildContext context, value, child) {
      return InkWell(
        onTap: onPress,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              Expanded(
                child: ColorFiltered(
                  colorFilter: ColorFilter.matrix(currentfilter[0].matrix), // agar [0] nhi lagaye toh error aa raha hai ki matrix defined toh kya karna hai dekh lena
                  child: SizedBox(
                    height: 60,
                    width: 60,
                    child: Image.memory(value.currentImage!,
                    fit: BoxFit.fill,
                    ),),
                ),
              ),
              Text(
                'dasad',
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
      );
    },
  );
}


