import 'package:flutter/material.dart';
import 'package:gestao_ejc/components/SnackBars/custom_snack_bar.dart';
import 'package:gestao_ejc/components/buttons/custom_cancel_button.dart';
import 'package:gestao_ejc/components/buttons/custom_confirmation_button.dart';
import 'package:gestao_ejc/components/forms/custom_model_form.dart';
import 'package:gestao_ejc/controllers/question_controller.dart';
import 'package:gestao_ejc/models/encounter_model.dart';
import 'package:gestao_ejc/models/question_model.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:uuid/uuid.dart';

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
  final QuestionController _questionController = getIt<QuestionController>();
  bool _isLoadingSaveQuestion = false;

  @override
  void initState() {
    super.initState();
    if (widget.editingQuestion != null) {
      _questionTextController.text = widget.editingQuestion!.question;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomModelForm(
      title: 'Nova Pergunta',
      formKey: _formKey,
      formBody: _buildFormBody(),
      actions: _buildFormAction(),
    );
  }

  _buildFormBody() {
    return [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          autofocus: true,
          keyboardType: TextInputType.text,
          controller: _questionTextController,
          decoration: const InputDecoration(
            hintText: 'Digite a nova pergunta...',
          ),
          validator: (questionText) {
            if (questionText == null || questionText.trim().isEmpty) {
              return 'Necessário informar a pergunta';
            }
            return null;
          },
          onFieldSubmitted: (_) {
            _saveQuestion();
          },
        ),
      )
    ];
  }

  _buildFormAction() {
    return [
      if (_isLoadingSaveQuestion) ...[
        const Text('Salvando pergunta, aguarde...'),
        const CircularProgressIndicator()
      ] else ...[
        CustomCancelButton(
          onPressed: () => Navigator.of(context).pop(),
        ),
        CustomConfirmationButton(
          onPressed: () {
            _saveQuestion();
          },
        ),
      ]
    ];
  }

  void _saveQuestion() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoadingSaveQuestion = true;
      });
      try {
        QuestionModel question = QuestionModel(
          id: widget.editingQuestion != null
              ? widget.editingQuestion!.id
              : Uuid().v4(),
          question: _questionTextController.text.trim(),
          sequentialEncounter: widget.encounter.sequential,
        );

        await _questionController.saveQuestion(question: question);
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
      Navigator.of(context).pop();
    }
  }
}
