import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:gestao_ejc/models/abstract_person_model.dart';
import 'package:gestao_ejc/models/uncle_model.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:gestao_ejc/services/person_service.dart';

class PersonController extends ChangeNotifier {
  final PersonService _personService = getIt<PersonService>();

  var _streamController;
  Stream<List<AbstractPersonModel>>? get stream => _streamController.stream;

  void init() {
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
      final persons = await _personService.getPersons();
      _streamController.add(persons);
    } catch (e) {
      _streamController.addError('Erro ao listar membros: $e');
    }
  }

  Future<void> savePerson({required AbstractPersonModel person}) async {
    try {
      await _personService.savePerson(person: person);
      getPersons();
    } catch (e) {
      debugPrint('Erro ao salvar pessoa: $e');
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
}
