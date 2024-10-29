import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:gestao_ejc/models/encounter_model.dart';
import 'package:gestao_ejc/services/encounter_service.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';

class EncounterController extends ChangeNotifier {
  final EncounterService _encounterService = getIt<EncounterService>();
  late bool response;
  var _streamController;

  Stream<List<EncounterModel>>? get stream => _streamController.stream;

  void init({String? transactionType}) {
    _streamController = StreamController<List<EncounterModel>>();
    getEncounter();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  Future<bool> saveEncounter({required EncounterModel encounter}) async {
    response = await _encounterService.saveEncounter(encounter: encounter);
    if (response) {
      getEncounter();
    }
    return response;
  }

  void getEncounter() async {
    List<EncounterModel>? encounters = await _encounterService.getEncounter();
    _streamController.sink.add(encounters);
  }

  void deleteEncounter({required EncounterModel encounter}) async {
    response = await _encounterService.deleteEncounter(encounter: encounter);
    if (response) {
      getEncounter();
    }
  }
}
