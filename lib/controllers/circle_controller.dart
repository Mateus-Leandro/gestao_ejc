import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:gestao_ejc/functions/function_int_to_roman.dart';
import 'package:gestao_ejc/models/circle_model.dart';
import 'package:gestao_ejc/services/circle_service.dart';
import 'package:gestao_ejc/services/firebase_storage_service.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';

class CircleController extends ChangeNotifier {
  var _streamController;
  final CircleService _circleService = getIt<CircleService>();
  final FirebaseStorageService firebaseStorageService =
      getIt<FirebaseStorageService>();
  final FunctionIntToRoman functionIntToRoman = getIt<FunctionIntToRoman>();
  Stream<List<CircleModel>>? get stream => _streamController.stream;
  List<CircleModel?>? circles;

  void init() {
    _streamController = StreamController<List<CircleModel>>();
    getCircles(null);
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  void getCircles(String? circleName) async {
    try {
      circles = await _circleService.getCircles(circleName?.toLowerCase());
      _streamController.sink.add(circles);
    } catch (e) {
      throw 'Erro ao buscar círculos: $e';
    }
  }

  Future<void> saveCircle({required CircleModel circle}) async {
    try {
      await _circleService.saveCircle(circle: circle);
      getCircles(null);
    } catch (e) {
      throw 'Erro ao salvar círculo: $e';
    }
  }

  Future<void> deleteCircle({required String circleId}) async {
    try {
      await _circleService.deleteCircle(circleId: circleId);
      getCircles(null);
    } catch (e) {
      throw 'Erro ao deletar círculo: $e';
    }
  }

  Future<String?> saveCircleImage(
      {required Uint8List image,
      required int sequentialEncounter,
      required String circleId,
      required String fileName}) async {
    try {
      String? url = await firebaseStorageService.uploadImage(
          image: image,
          path:
              'encounters/${functionIntToRoman.convert(sequentialEncounter)}/circles/$circleId/$fileName.png');
      return url ?? '';
    } catch (e) {
      throw 'Erro ao salvar imagem: $e';
    }
  }

  Future<Uint8List?> getCircleImage({
    required int sequentialEncounter,
    required String circleId,
    required String fileName,
  }) async {
    try {
      return await firebaseStorageService.getImage(
          imagePath:
              'encounters/${functionIntToRoman.convert(sequentialEncounter)}/circles/$circleId/$fileName.png');
    } catch (e) {
      throw 'Erro ao obter imagem do círculo: $e';
    }
  }

  Future<void> removeCircleImage({
    required int sequentialEncounter,
    required String circleId,
    required String fileName,
  }) async {
    try {
      await firebaseStorageService.deleteImage(
          imagePath:
              'encounters/${functionIntToRoman.convert(sequentialEncounter)}/circles/$circleId/$fileName.png');
    } catch (e) {
      throw 'Erro ao remover imagem do círculo: $e';
    }
  }
}
