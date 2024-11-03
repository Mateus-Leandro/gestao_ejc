import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:gestao_ejc/functions/function_int_to_roman.dart';
import 'package:gestao_ejc/models/encounter_model.dart';
import 'package:gestao_ejc/services/encounter_service.dart';
import 'package:gestao_ejc/services/firebase_storage_service.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';

class EncounterController extends ChangeNotifier {
  final EncounterService _encounterService = getIt<EncounterService>();
  final FirebaseStorageService firebaseStorageService =
      getIt<FirebaseStorageService>();
  final FunctionIntToRoman functionIntToRoman = getIt<FunctionIntToRoman>();
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

  Future<bool> saveEncounter(
      {required EncounterModel encounter, required bool newEncounter}) async {
    if (newEncounter) {
      encounter.sequential = await getLastSequentialEncounter() + 1;
    }
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

  Future<int> getLastSequentialEncounter() async {
    return await _encounterService.getLastSequentialEncounter();
  }

  void deleteEncounter({required EncounterModel encounter}) async {
    response = await _encounterService.deleteEncounter(encounter: encounter);
    if (response) {
      getEncounter();
    }
  }

  Future<String> saveImageTheme(
      {required int sequential, required Uint8List imageTheme}) async {
    String? response = await firebaseStorageService.uploadImage(
        image: imageTheme,
        path:
            'encounters/${functionIntToRoman.convert(sequential)}/themeImage/themeImage.jpeg');
    return response ?? '';
  }

  Future<Uint8List?> getImageTheme({required int sequential}) async {
    return await firebaseStorageService.getImage(
        imagePath:
            'encounters/${functionIntToRoman.convert(sequential)}/themeImage/themeImage.jpeg');
  }

  Future<void> removeImageTheme({required int sequential}) async {
    await firebaseStorageService.deleteImage(
        imagePath:
            'encounters/${functionIntToRoman.convert(sequential)}/themeImage/themeImage.jpeg');
  }
}
