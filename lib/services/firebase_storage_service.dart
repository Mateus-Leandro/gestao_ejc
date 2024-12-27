import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:image/image.dart' as img;

class FirebaseStorageService {
  FirebaseStorage _firebaseStorage = getIt<FirebaseStorage>();
  SettableMetadata? metadata;

  Future<Uint8List?> getImage({required String imagePath}) async {
    try {
      Reference ref = _firebaseStorage.ref().child(imagePath);
      Uint8List? imageData = await ref.getData();
      return imageData;
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> uploadImage({
    required Uint8List image,
    required String path,
  }) async {
    try {
      metadata = SettableMetadata(contentType: 'image/png');
      final ref = _firebaseStorage.ref().child(path);
      await ref.putData(image, metadata);

      String downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteImage({required String imagePath}) async {
    try {
      await _firebaseStorage.ref().child(imagePath).delete();
    } catch (e) {
      rethrow;
    }
  }

  Uint8List? compressAndResizeImage(Uint8List imageData) {
    try {
      final image = img.decodeImage(imageData);

      if (image == null) return null;

      final resized = img.copyResize(image, width: 1024, height: 1024);
      final compressed = img.encodePng(resized);

      return Uint8List.fromList(compressed);
    } catch (e) {
      rethrow;
    }
  }
}
