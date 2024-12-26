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

  Future<void> saveEncounter(
      {required EncounterModel encounter, required bool newEncounter}) async {
    try {
      if (newEncounter) {
        encounter.sequential = await getLastSequentialEncounter() + 1;
      }
      await _encounterService.saveEncounter(encounter: encounter);
      getEncounter();
    } catch (e) {
      throw 'Erro so salvar encontro: $e';
    }
  }

  void getEncounter() async {
    try {
      List<EncounterModel>? encounters = await _encounterService.getEncounter();
      _streamController.sink.add(encounters);
    } catch (e) {
      throw 'Erro ao buscar encontros: $e';
    }
  }

  Future<int> getLastSequentialEncounter() async {
    try {
      return await _encounterService.getLastSequentialEncounter();
    } catch (e) {
      throw 'Erro ao buscar numero do ultimo encontro: $e';
    }
  }

  Future<void> deleteEncounter({required EncounterModel encounter}) async {
    try {
      await _encounterService.deleteEncounter(encounter: encounter);
      getEncounter();
    } catch (e) {
      throw 'Erro ao deletar encontro: $e';
    }
  }

  Future<String> saveImageTheme(
      {required int sequential, required Uint8List imageTheme}) async {
    String? urlDownload = await firebaseStorageService.uploadImage(
        image: imageTheme,
        path:
            'encounters/${functionIntToRoman.convert(sequential)}/themeImage/themeImage.png');
    return urlDownload ?? '';
  }

  Future<Uint8List?> getImageTheme({required int sequential}) async {
    return await firebaseStorageService.getImage(
        imagePath:
            'encounters/${functionIntToRoman.convert(sequential)}/themeImage/themeImage.png');
  }

  Future<void> removeImageTheme({required int sequential}) async {
    await firebaseStorageService.deleteImage(
        imagePath:
            'encounters/${functionIntToRoman.convert(sequential)}/themeImage/themeImage.png');
  }
}
