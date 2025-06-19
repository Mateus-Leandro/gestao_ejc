import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gestao_ejc/enums/circle_color_enum.dart';
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
  List<CircleModel> circles = [];

  void init({required int sequentialEncounter}) {
    _streamController = StreamController<List<CircleModel>>();
    getCircles(circleName: null, sequentialEncounter: sequentialEncounter);
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  void getCircles(
      {required String? circleName, required int sequentialEncounter}) async {
    try {
      circles = await _circleService.getCircles(sequentialEncounter);
      _streamController.sink.add(circleName != null
          ? filterCircles(
              listCircleModel: circles,
              circleName: circleName,
            )
          : circles);
    } catch (e) {
      throw 'Erro ao buscar círculos: $e';
    }
  }

  Future<void> saveCircle({required CircleModel circle}) async {
    try {
      await _circleService.saveCircle(circle: circle);
      getCircles(
          circleName: null, sequentialEncounter: circle.sequentialEncounter);
    } catch (e) {
      throw 'Erro ao salvar círculo: $e';
    }
  }

  Future<void> deleteCircle({required CircleModel circle}) async {
    try {
      await _circleService.deleteCircle(circleId: circle.id);
      getCircles(
          circleName: null, sequentialEncounter: circle.sequentialEncounter);
    } catch (e) {
      throw 'Erro ao deletar círculo: $e';
    }
  }

  Future<String> saveCircleImage(
      {required Uint8List image,
      required int sequentialEncounter,
      required CircleModel circle,
      required String fileName}) async {
    try {
      String? url = await firebaseStorageService.uploadImage(
          image: image,
          path:
              'encounters/${functionIntToRoman.convert(sequentialEncounter)}/circles/${circle.id}/$fileName.png');
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

  Future<void> updateImages({required CircleModel circle}) async {
    try {
      await _circleService.updateUrlImages(circle: circle);
      getCircles(
          circleName: null, sequentialEncounter: circle.sequentialEncounter);
    } catch (e) {
      throw 'Erro ao atualizar imagens do círculo: $e';
    }
  }

  List<CircleModel>? filterCircles(
      {required List<CircleModel> listCircleModel,
      required String circleName}) {
    return listCircleModel.where((doc) {
      return doc.name.toLowerCase().contains(circleName.toLowerCase());
    }).toList();
  }

  List<CircleColorEnum> get circleColors {
    return circles
        .map((circle) => circle.color)
        .toSet()
        .toList()
        .cast<CircleColorEnum>();
  }

  Future<DocumentReference?> referenceCircleByTypeAndEncounter(
      {required CircleColorEnum circleColor,
      required int sequentialEncounter}) async {
    try {
      return await _circleService.referenceCircleByTypeAndEncounter(
          circle: circleColor, sequentialEncounter: sequentialEncounter);
    } catch (e) {
      throw 'Erro ao buscar referencia da equipe!';
    }
  }

  Future<CircleModel> circleByReference(
      {required DocumentReference referenceCircle}) async {
    try {
      return await _circleService.circleByReference(
          referenceCircle: referenceCircle);
    } catch (e) {
      throw 'Erro ao buscar equipe';
    }
  }
}
