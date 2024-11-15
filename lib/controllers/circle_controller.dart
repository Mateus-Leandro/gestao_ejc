import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gestao_ejc/models/circle_model.dart';
import 'package:gestao_ejc/services/circle_service.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';

class CircleController extends ChangeNotifier {
  var _streamController;
  final CircleService _circleService = getIt<CircleService>();
  Stream<List<CircleModel>>? get stream => _streamController.stream;

  void init() {
    _streamController = StreamController<List<CircleModel>>();
    getAllCircles();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  Future<bool> saveCircle(CircleModel circle) async {
    return await _circleService.saveCircle(circle: circle);
  }

  void getAllCircles() async {
    List<CircleModel?> circles = await _circleService.getAllCircles();
    _streamController.sink.add(circles);
  }

  Future<bool> deleteCircle({required String circleId}) async {
    return await _circleService.deleteCircle(circleId: circleId);
  }
}
