import 'package:flutter/material.dart';
import 'package:gestao_ejc/components/SnackBars/custom_snack_bar.dart';
import 'package:gestao_ejc/components/buttons/custom_cancel_button.dart';
import 'package:gestao_ejc/components/buttons/custom_confirmation_button.dart';
import 'package:gestao_ejc/components/forms/custom_model_form.dart';
import 'package:gestao_ejc/controllers/question_theme_controller.dart';
import 'package:gestao_ejc/models/encounter_model.dart';
import 'package:gestao_ejc/models/question_theme_model.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:uuid/uuid.dart';

class CustomQuestionThemeForm extends StatefulWidget {
  final EncounterModel encounter;
  final QuestionThemeModel? editingQuestionTheme;
  const CustomQuestionThemeForm(
      {super.key, this.editingQuestionTheme, required this.encounter});

  @override
  State<CustomQuestionThemeForm> createState() =>
      _CustomQuestionThemeFormState();
}

class _CustomQuestionThemeFormState extends State<CustomQuestionThemeForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _questionThemeTextController =
      TextEditingController();
  final QuestionThemeController _questionThemeController =
      getIt<QuestionThemeController>();
  bool _isLoadingSaveQuestionTheme = false;

  @override
  void initState() {
    super.initState();
    if (widget.editingQuestionTheme != null) {
      _questionThemeTextController.text =
          widget.editingQuestionTheme?.description ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomModelForm(
      title: widget.editingQuestionTheme == null ? 'Novo Tema' : 'Editar Tema',
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
          controller: _questionThemeTextController,
          decoration: const InputDecoration(
            hintText: 'Digite o novo tema..',
          ),
          validator: (questionThemeText) {
            if (questionThemeText == null || questionThemeText.trim().isEmpty) {
              return 'Necessário informar descrição do tema';
            }
            return null;
          },
          onFieldSubmitted: (_) {
            _saveQuestionTheme();
          },
        ),
      )
    ];
  }

  _buildFormAction() {
    return [
      if (_isLoadingSaveQuestionTheme) ...[
        const Text('Salvando tema, aguarde...'),
        const CircularProgressIndicator()
      ] else ...[
        CustomCancelButton(
          onPressed: () => Navigator.of(context).pop(),
        ),
        CustomConfirmationButton(
          onPressed: () {
            _saveQuestionTheme();
          },
        ),
      ]
    ];
  }

  void _saveQuestionTheme() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoadingSaveQuestionTheme = true;
      });
      try {
        QuestionThemeModel theme = QuestionThemeModel(
          id: widget.editingQuestionTheme == null
              ? const Uuid().v4()
              : widget.editingQuestionTheme!.id,
          description: _questionThemeTextController.text.trim(),
        );

        await _questionThemeController.saveQuestionTheme(
          questionTheme: theme,
          sequentialEncounter: widget.encounter.sequential,
        );
      } catch (e) {
        CustomSnackBar.show(
          context: context,
          message: 'Erro ao salvar tema: $e',
          colorBar: Colors.red,
        );
      }

      setState(() {
        _isLoadingSaveQuestionTheme = false;
      });
      Navigator.of(context).pop();
    }
  }
}
