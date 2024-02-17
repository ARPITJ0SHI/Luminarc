import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AppImagePicker {
  pick({required ImageSource source, required Function(File?) onPick}) async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      onPick(File(image.path));
      print("${image.path} file picked successfully");
    } else {
      onPick(null);
      print("file not picked ");
    }
  }
}
