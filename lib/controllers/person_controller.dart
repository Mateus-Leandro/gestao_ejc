import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:gestao_ejc/models/abstract_person_model.dart';
import 'package:gestao_ejc/models/uncle_model.dart';
import 'package:gestao_ejc/services/firebase_storage_service.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:gestao_ejc/services/person_service.dart';

class PersonController extends ChangeNotifier {
  final PersonService _personService = getIt<PersonService>();
  final FirebaseStorageService firebaseStorageService =
      getIt<FirebaseStorageService>();
  List<AbstractPersonModel> listPersons = [];
  List<AbstractPersonModel> filteredListPersons = [];

  var _streamController;
  Stream<List<AbstractPersonModel>>? get stream => _streamController.stream;

  void init() {
    _streamController = StreamController<List<AbstractPersonModel>>();
    getPersons();
  }

  @override
  void dispose() {
    if (!_streamController.isClosed) {
      _streamController.close();
    }
    super.dispose();
  }

  Future<void> getPersons() async {
    try {
      listPersons = await _personService.getPersons();
      filteredListPersons = listPersons;
      _streamController.sink.add(listPersons);
    } catch (e) {
      _streamController.addError('Erro ao listar membros: $e');
    }
  }

  void filterPerson({required String? personName}) {
    try {
      personName != null
          ? filteredListPersons = listPersons
              .where((person) =>
                  person.name.toLowerCase().contains(personName.toLowerCase()))
              .toList()
          : filteredListPersons = listPersons;

      _streamController.sink.add(filteredListPersons);
    } catch (e) {
      throw 'Erro ao buscar membro/tios';
    }
  }

  Future<void> savePerson({required AbstractPersonModel person}) async {
    try {
      await _personService.savePerson(person: person);
      getPersons();
    } catch (e) {
      throw Exception('Erro ao salvar pessoa: $e');
    }
  }

  Future<void> deletePerson({required AbstractPersonModel person}) async {
    try {
      if (person is UncleModel) {
        for (var uncle in person.uncles) {
          await _personService.deletePerson(personId: uncle.id);
        }
      } else {
        await _personService.deletePerson(personId: person.id);
      }
      getPersons();
    } catch (e) {
      debugPrint('Erro ao deletar pessoa: $e');
      throw Exception('Erro ao deletar pessoa: $e');
    }
  }

  Future<Uint8List?> getPersonImage(
      {required AbstractPersonModel person}) async {
    try {
      return await firebaseStorageService.getImage(
          imagePath: 'persons/${person.id}/personImage.png');
    } catch (e) {
      throw 'Erro ao retornar imagem: $e';
    }
  }

  Future<String> savePersonImage(
      {required Uint8List image, required AbstractPersonModel person}) async {
    try {
      String? url = await firebaseStorageService.uploadImage(
          image: image, path: 'persons/${person.id}/personImage.png');
      return url ?? '';
    } catch (e) {
      throw 'Erro ao salvar imagem: $e';
    }
  }

  Future<void> updateImage({required AbstractPersonModel person}) async {
    try {
      await _personService.updateUrlImage(person: person);
      await getPersons();
    } catch (e) {
      throw 'Erro ao atualizar imagem: $e';
    }
  }

  Future<void> removePersonImage({
    required AbstractPersonModel person,
  }) async {
    try {
      await firebaseStorageService.deleteImage(
          imagePath: 'persons/${person.id}/personImage.png');
    } catch (e) {
      throw 'Erro ao remover imagem: $e';
    }
  }
}
