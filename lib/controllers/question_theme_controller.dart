import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gestao_ejc/controllers/question_controller.dart';
import 'package:gestao_ejc/models/question_theme_model.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:gestao_ejc/services/question_theme_service.dart';

class QuestionThemeController extends ChangeNotifier {
  final QuestionController _questionController = getIt<QuestionController>();
  final QuestionThemeService _questionThemeService =
      getIt<QuestionThemeService>();
  List<QuestionThemeModel> listThemes = [];
  List<QuestionThemeModel> filteredListThemes = [];

  var _streamController = StreamController<List<QuestionThemeModel>>();

  Stream<List<QuestionThemeModel>>? get stream => _streamController.stream;

  void init() {
    getQuestionThemes(null);
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  Future<void> saveQuestionTheme(
      {required QuestionThemeModel questionTheme,
      required int sequentialEncounter}) async {
    try {
      await _questionThemeService.saveQuestionTheme(question: questionTheme);
      getQuestionThemes(null);
      _questionController.init(sequentialEncounter: sequentialEncounter);
    } catch (e) {
      throw 'Erro ao salvar tema: $e';
    }
  }

  Future<void> getQuestionThemes(String? themeDescription) async {
    try {
      listThemes =
          await _questionThemeService.getQuestionThemes(themeDescription);
      _streamController.sink.add(listThemes);
    } catch (e) {
      throw 'Erro ao buscar tema : $e';
    }
  }

  Future<void> deleteQuestionTheme(
      {required QuestionThemeModel questionTheme,
      required int sequentialEncounter}) async {
    try {
      await _questionThemeService.deleteQuestionTheme(question: questionTheme);
      getQuestionThemes(null);
      _questionController.init(sequentialEncounter: sequentialEncounter);
    } catch (e) {
      throw 'Erro ao deletar tema: $e';
    }
  }

  void filterPerson({required String? themeDescription}) {
    try {
      themeDescription != null
          ? filteredListThemes = listThemes
              .where((theme) => theme.description
                  .toLowerCase()
                  .contains(themeDescription.toLowerCase()))
              .toList()
          : filteredListThemes = listThemes;

      _streamController.sink.add(filteredListThemes);
    } catch (e) {
      throw 'Erro ao buscar themas';
    }
  }

  List<QuestionThemeModel> get allListThemes => listThemes;
}
