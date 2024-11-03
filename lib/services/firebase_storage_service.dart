import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';

class FirebaseStorageService {
  FirebaseStorage _firebaseStorage = getIt<FirebaseStorage>();
  SettableMetadata? metadata;

  Future<Uint8List?> getImage({required String imagePath}) async {
    try {
      Reference ref = _firebaseStorage.ref().child(imagePath);
      Uint8List? imageData = await ref.getData();
      return imageData;
    } catch (e) {
      print('Erro ao obter a imagem: $e');
      return null;
    }
  }

  Future<String?> uploadImage({
    required Uint8List image,
    required String path,
  }) async {
    try {
      metadata = SettableMetadata(contentType: 'image/jpeg');
      final ref = _firebaseStorage.ref().child(path);
      await ref.putData(image, metadata);

      String downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Erro ao fazer upload da imagem: $e');
      return null;
    }
  }

  Future<void> deleteImage({required String imagePath}) async {
    await _firebaseStorage.ref().child(imagePath).delete();
  }
}
