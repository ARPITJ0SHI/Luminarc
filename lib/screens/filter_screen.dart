import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:luminarc/Provider/imageProvider.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

import '../Models/filter_model.dart';

import '../helper/filters.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late Filter currentfilter;
  late List<Filter> filters;
  late AppImageProvider appImageProvider;
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    filters = Filters().list();
    currentfilter = filters[0];
    appImageProvider = Provider.of<AppImageProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black87,
          leading: const CloseButton(color: Colors.white),
          title: const Text('filters',style: TextStyle(color: Colors.white),),
          actions: [
            IconButton(
                onPressed: () async {
                  screenshotController
                      .capture()
                      .then((Uint8List? image) {})
                      .catchError((onError) {
                    print(onError);
                  });
                  final Uint8List? bytes = await screenshotController.capture();
                  appImageProvider.changeImage(bytes!);
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.done,color: Colors.white))
          ],
        ),
        body: Center(
          child: Consumer<AppImageProvider>(
            builder: (BuildContext context, value, child) {
              if (value.currentImage != null) {
                return Screenshot(
                  controller: screenshotController,
                  child: ColorFiltered(
                      colorFilter: ColorFilter.matrix(currentfilter.matrix),
                      child: Image.memory(
                        value.currentImage!,
                        fit: BoxFit.cover,
                      )),
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
        bottomNavigationBar: Container(
            height: 120,
            width: double.infinity,
            color: Colors.black,
            child: SafeArea(child: Consumer<AppImageProvider>(
                builder: (BuildContext context, value, child) {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: filters.length,
                itemBuilder: (BuildContext context, int index) {
                  Filter filter = filters[index];
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
                                onTap: () {
                                  setState(() {
                                    currentfilter = filter;
                                  });
                                },
                                child: ColorFiltered(
                                  colorFilter:
                                      ColorFilter.matrix(filter.matrix),
                                  child: Image.memory(value.currentImage!),
                                ),
                              ),
                            )),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          filter.filterName,
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(color: Colors.white54)),
                        )
                      ],
                    ),
                  );
                },
              );
            }))));
  }
}
