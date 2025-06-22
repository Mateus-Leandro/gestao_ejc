import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gestao_ejc/components/SnackBars/custom_snack_bar.dart';
import 'package:gestao_ejc/components/buttons/custom_cancel_button.dart';
import 'package:gestao_ejc/components/buttons/custom_confirmation_button.dart';
import 'package:gestao_ejc/components/forms/custom_model_form.dart';
import 'package:gestao_ejc/controllers/question_controller.dart';
import 'package:gestao_ejc/controllers/question_theme_controller.dart';
import 'package:gestao_ejc/models/encounter_model.dart';
import 'package:gestao_ejc/models/question_model.dart';
import 'package:gestao_ejc/models/question_theme_model.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:uuid/uuid.dart';
import 'package:collection/collection.dart';

class CustomQuestionForm extends StatefulWidget {
  final EncounterModel encounter;
  final QuestionModel? editingQuestion;
  const CustomQuestionForm({
    super.key,
    required this.encounter,
    this.editingQuestion,
  });

  @override
  State<CustomQuestionForm> createState() => _CustomQuestionFormState();
}

class _CustomQuestionFormState extends State<CustomQuestionForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _questionTextController = TextEditingController();
  final FocusNode _questionFocusNode = FocusNode();

  final QuestionController _questionController = getIt<QuestionController>();
  final QuestionThemeController _questionThemeController =
      getIt<QuestionThemeController>();

  bool _isLoadingSaveQuestion = false;
  bool _isLoadingThemes = false;
  QuestionThemeModel? _selectedTheme;

  @override
  void initState() {
    super.initState();
    if (widget.editingQuestion != null) {
      _questionTextController.text = widget.editingQuestion!.question;
    }
    _loadThemes();
  }

  @override
  void dispose() {
    super.dispose();
    _questionTextController.dispose();
    _questionFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomModelForm(
      title:
          widget.editingQuestion != null ? 'Editar pergunta' : 'Nova Pergunta',
      formKey: _formKey,
      formBody: _buildFormBody(),
      actions: _buildFormAction(),
    );
  }

  _buildFormBody() {
    return [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: _isLoadingThemes
            ? const Center(child: CircularProgressIndicator())
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Informe o Tema',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  DropdownButton<QuestionThemeModel>(
                    isExpanded: true,
                    value: _questionThemeController.allListThemes
                            .contains(_selectedTheme)
                        ? _selectedTheme
                        : null,
                    hint: const Text('Selecione um tema'),
                    icon: const Icon(Icons.arrow_drop_down),
                    items: _questionThemeController.allListThemes.map((theme) {
                      return DropdownMenuItem<QuestionThemeModel>(
                        value: theme,
                        child: Text(theme.description),
                      );
                    }).toList(),
                    onChanged: (selected) {
                      setState(() {
                        _selectedTheme = selected;
                      });
                      FocusScope.of(context).requestFocus(_questionFocusNode);
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    focusNode: _questionFocusNode,
                    keyboardType: TextInputType.text,
                    controller: _questionTextController,
                    decoration: const InputDecoration(
                      hintText: 'Digite a nova pergunta...',
                    ),
                    validator: (questionText) {
                      if (questionText == null || questionText.trim().isEmpty) {
                        return 'Necessário informar a pergunta';
                      }
                      if (_selectedTheme == null) {
                        return 'Selecione um tema';
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) {
                      _saveQuestion();
                    },
                  ),
                ],
              ),
      ),
    ];
  }

  _buildFormAction() {
    if (_isLoadingSaveQuestion) {
      return [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 12),
              Text('Salvando pergunta, aguarde...'),
            ],
          ),
        )
      ];
    }

    return [
      CustomCancelButton(
        onPressed: () => Navigator.of(context).pop(),
      ),
      CustomConfirmationButton(
        onPressed: () {
          _saveQuestion();
        },
      ),
    ];
  }

  void _saveQuestion() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoadingSaveQuestion = true;
      });

      try {
        final DocumentReference referenceTheme = FirebaseFirestore.instance
            .collection('question_themes')
            .doc(_selectedTheme?.id);

        final question = QuestionModel(
          id: widget.editingQuestion != null
              ? widget.editingQuestion!.id
              : const Uuid().v4(),
          question: _questionTextController.text.trim(),
          sequentialEncounter: widget.encounter.sequential,
          referenceTheme: referenceTheme,
        );

        await _questionController.saveQuestion(question: question);
        Navigator.of(context).pop();
      } catch (e) {
        CustomSnackBar.show(
          context: context,
          message: 'Erro ao salvar pergunta: $e',
          colorBar: Colors.red,
        );
      }

      setState(() {
        _isLoadingSaveQuestion = false;
      });
    }
  }

  _loadThemes() async {
    try {
      setState(() {
        _isLoadingThemes = true;
      });

      await _questionThemeController.getQuestionThemes(null);

      if (widget.editingQuestion?.theme != null) {
        _selectedTheme =
            _questionThemeController.allListThemes.firstWhereOrNull(
          (theme) => theme.id == widget.editingQuestion!.theme?.id,
        );
      }

      setState(() {
        _isLoadingThemes = false;
      });
    } catch (e) {
      CustomSnackBar.show(
        context: context,
        message: 'Erro ao carregar temas: $e',
        colorBar: Colors.red,
      );
    }
  }
}
