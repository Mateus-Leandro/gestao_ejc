import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gestao_ejc/models/circle_model.dart';
import 'package:gestao_ejc/services/circle_service.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';

class CircleController extends ChangeNotifier {
  var _streamController;
  final CircleService _circleService = getIt<CircleService>();
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
}
