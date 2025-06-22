import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gestao_ejc/models/question_model.dart';
import 'package:gestao_ejc/models/question_theme_model.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:gestao_ejc/services/question_service.dart';

class QuestionController extends ChangeNotifier {
  final QuestionService _questionService = getIt<QuestionService>();

  var _streamController;

  Stream<List<QuestionModel>>? get stream => _streamController.stream;
  List<QuestionModel> listQuestion = [];

  void init({required int sequentialEncounter}) {
    _streamController = StreamController<List<QuestionModel>>();
    getQuestions(sequentialEncounter: sequentialEncounter);
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  Future<void> saveQuestion({required QuestionModel question}) async {
    try {
      await _questionService.saveQuestion(question: question);
      getQuestions(sequentialEncounter: question.sequentialEncounter);
    } catch (e) {
      throw 'Erro ao salvar pergunta: $e';
    }
  }

  Future<void> getQuestions(
      {required int sequentialEncounter, String? searchedText}) async {
    try {
      listQuestion = await _questionService.getQuestions(
          sequentialEncounter: sequentialEncounter);
      await fillThemeList();
      _streamController.sink.add(
        searchedText != null
            ? filterQuestion(
                listQuestionModel: listQuestion,
                searchedText: searchedText,
              )
            : listQuestion,
      );
    } catch (e) {
      throw 'Erro ao buscar perguntas : $e';
    }
  }

  Future<void> deleteQuestion({required QuestionModel question}) async {
    try {
      await _questionService.deleteQuestion(question: question);
      getQuestions(sequentialEncounter: question.sequentialEncounter);
    } catch (e) {
      throw 'Erro ao deletar pergunta: $e';
    }
  }

  List<QuestionModel>? filterQuestion(
      {required List<QuestionModel> listQuestionModel,
      required String searchedText}) {
    return listQuestionModel.where((doc) {
      return doc.question.toLowerCase().contains(searchedText.toLowerCase());
    }).toList();
  }

  Future<void> fillThemeList() async {
    Future.wait(listQuestion.map((question) async {
      final themeByReference = await question.referenceTheme?.get();
      if (themeByReference != null) {
        if (themeByReference.exists && themeByReference.data() != null) {
          question.theme = QuestionThemeModel.fromJson(
              themeByReference.data() as Map<String, dynamic>);
        }
      }
    }));
  }
}
