import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppImageProvider extends ChangeNotifier {
  Uint8List? _originalImage; 
  Uint8List? _currentImage; 

  Uint8List? get originalImage => _originalImage;
  Uint8List? get currentImage => _currentImage;

 
  Future<void> changeImageFile(File image) async {
    try {
      _currentImage = await image.readAsBytes();
      _originalImage = _currentImage; // Set the original image
      notifyListeners();
    } catch (e) {
      print('Failed to read image: $e');
    }
  }

 
  void changeImage(Uint8List image) {
    _currentImage = image; 
    notifyListeners(); 
  }

  @override
  void dispose() {
    super.dispose();
  }
}

// class AppImageProvider extends ChangeNotifier {
//   Uint8List? currentImage;

//   changeImageFile(File image) async {
//     try {
//       currentImage = await image.readAsBytes();
//       print("Image bytes read: ${currentImage?.length}");
//       notifyListeners();
//     } catch (e) {
//       print('Failed to read image: $e');
//     }
//   }

//   changeImage(Uint8List image) async {
//     try {
//       currentImage = await image;
//       notifyListeners();
//     } catch (e) {
//       print('Failed to read image: $e');
//     }
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

 
// }
