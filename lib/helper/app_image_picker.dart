import 'dart:io';
import 'package:image_picker/image_picker.dart';

typedef ImagePickCallback = void Function(File? image);

class AppImagePicker {
  Future<void> pick(
      {required ImageSource source, required ImagePickCallback onPick}) async {
    final picker = ImagePicker();

    try {
      final XFile? pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        onPick(File(pickedFile.path));
        print("$pickedFile picked successfully");
      } else {
        onPick(null);
        print('null image');
      }
    } catch (e) {
      print("image pick failed $e");
    }
  }
}
