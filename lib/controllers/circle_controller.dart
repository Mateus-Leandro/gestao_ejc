import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gestao_ejc/models/circle_model.dart';
import 'package:gestao_ejc/services/circle_service.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';

class CircleController extends ChangeNotifier {
  var _streamController;
  String? response;
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
    circles = await _circleService.getCircles(circleName?.toLowerCase());
    _streamController.sink.add(circles);
  }

  Future<String?> saveCircle({required CircleModel circle}) async {
    response = await _circleService.saveCircle(circle: circle);
    if (response == null) {
      getCircles(null);
      return null;
    }
    return response;
  }

  Future<String?> deleteCircle({required String circleId}) async {
    response = await _circleService.deleteCircle(circleId: circleId);
    if (response == null) {
      getCircles(null);
      return null;
    }
    return response;
  }
}
