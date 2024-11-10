import 'dart:typed_data';
import 'package:gestao_ejc/services/firebase_storage_service.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:image/image.dart' as img;

class FunctionPickImage {
  Uint8List? _singleImage;
  final FirebaseStorageService firebaseStorageService =
      getIt<FirebaseStorageService>();

  Future<Uint8List?> getSingleImage() async {
    _singleImage = await ImagePickerWeb.getImageAsBytes();
    return _singleImage != null
        ? firebaseStorageService.compressAndResizeImage(_singleImage!)
        : null;
  }
}
