import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gestao_ejc/models/question_theme_model.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:gestao_ejc/services/question_theme_service.dart';

class QuestionThemeController extends ChangeNotifier {
  final QuestionThemeService _questionThemeService =
      getIt<QuestionThemeService>();

  var _streamController;

  Stream<List<QuestionThemeModel>>? get stream => _streamController.stream;

  void init() {
    _streamController = StreamController<List<QuestionThemeModel>>();
    getQuestionThemes(null);
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  Future<void> saveQuestionTheme(
      {required QuestionThemeModel questionTheme}) async {
    try {
      await _questionThemeService.saveQuestionTheme(question: questionTheme);
      getQuestionThemes(null);
    } catch (e) {
      throw 'Erro ao salvar tema: $e';
    }
  }

  Future<void> getQuestionThemes(String? themeDescription) async {
    try {
      var response =
          await _questionThemeService.getQuestionThemes(themeDescription);
      _streamController.sink.add(response);
    } catch (e) {
      throw 'Erro ao buscar tema : $e';
    }
  }

  Future<void> deleteQuestion(
      {required QuestionThemeModel questionTheme}) async {
    try {
      await _questionThemeService.deleteQuestionTheme(question: questionTheme);
      getQuestionThemes(null);
    } catch (e) {
      throw 'Erro ao deletar tema: $e';
    }
  }
}
