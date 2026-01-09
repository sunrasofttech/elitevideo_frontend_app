import 'package:image_picker/image_picker.dart';

class ImagePickerUtil {
  static final ImagePicker _picker = ImagePicker();

  static Future<XFile?> pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    return pickedFile;
  }

  static Future<XFile?> pickImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    return pickedFile;
  }

  static Future<XFile?> pickVideoFromGallery() async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
    return pickedFile;
  }

  static Future<XFile?> pickVideoFromCamera() async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.camera);
    return pickedFile;
  }
}
