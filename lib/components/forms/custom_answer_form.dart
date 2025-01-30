import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gestao_ejc/components/SnackBars/custom_snack_bar.dart';
import 'package:gestao_ejc/components/buttons/custom_cancel_button.dart';
import 'package:gestao_ejc/components/buttons/custom_confirmation_button.dart';
import 'package:gestao_ejc/components/drawers/custom_color_drawer.dart';
import 'package:gestao_ejc/components/forms/custom_model_form.dart';
import 'package:gestao_ejc/controllers/answer_controller.dart';
import 'package:gestao_ejc/functions/function_color.dart';
import 'package:gestao_ejc/models/answer_model.dart';
import 'package:gestao_ejc/models/encounter_model.dart';
import 'package:gestao_ejc/models/question_model.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:uuid/uuid.dart';

class CustomAnswerForm extends StatefulWidget {
  final EncounterModel encounter;
  final QuestionModel question;
  final AnswerModel? answer;
  const CustomAnswerForm({
    super.key,
    required this.encounter,
    required this.question,
    this.answer,
  });

  @override
  State<CustomAnswerForm> createState() => _CustomAnswerFormState();
}

class _CustomAnswerFormState extends State<CustomAnswerForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _answerTextController = TextEditingController();
  final AnswerController _answerController = getIt<AnswerController>();
  FunctionColor _functionColor = getIt<FunctionColor>();
  String? _colorSelectionError;
  bool _isLoadingSaveAnswer = false;
  String? selectedColorHex;
  Color? initialColor;

  @override
  void initState() {
    super.initState();
    if (widget.answer != null) {
      _answerTextController.text = widget.answer!.answer;
      selectedColorHex = widget.answer!.hexColorCircle;
      initialColor = _functionColor.getFromHexadecimal(selectedColorHex!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomModelForm(
      title: 'Resposta',
      formKey: _formKey,
      formBody: _buildFormBody(),
      actions: _buildFormAction(),
    );
  }

  _buildFormBody() {
    return [
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 7),
            child: Text(
              widget.question.question,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(
            height: 4,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Text('Cor do Círculo:'),
              ),
              CustomColorDrawer(
                initialColor: initialColor,
                colorSelected: (newColor) {
                  setState(
                    () {
                      selectedColorHex = newColor[2];
                      _colorSelectionError = null;
                    },
                  );
                },
                tooltipMessage: widget.answer == null
                    ? 'Selecione a cor do círculo que responde a pergunta'
                    : '',
                allowSelection: widget.answer == null,
              ),
            ],
          ),
          if (_colorSelectionError != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Text(
                _colorSelectionError!,
                style: const TextStyle(color: Colors.red, fontSize: 13),
              ),
            ),
          ],
          TextFormField(
            controller: _answerTextController,
            canRequestFocus: true,
            decoration: const InputDecoration(
              hintText: 'Digite a resposta...',
            ),
            validator: (answerText) {
              if (answerText == null || answerText.isEmpty) {
                return 'Informe a resposta';
              }
              return null;
            },
            onFieldSubmitted: (_) {
              _saveAnswer();
            },
          )
        ],
      )
    ];
  }

  _buildFormAction() {
    return [
      if (_isLoadingSaveAnswer) ...[
        const Text('Salvando resposta, aguarde...'),
        const CircularProgressIndicator()
      ] else ...[
        CustomCancelButton(
          onPressed: () => Navigator.of(context).pop(),
        ),
        CustomConfirmationButton(
          onPressed: () {
            _saveAnswer();
          },
        ),
      ]
    ];
  }

  void _saveAnswer() async {
    if (selectedColorHex == null) {
      setState(() {
        _colorSelectionError = 'Necessário informar a cor do círculo';
      });
    } else {
      if (_formKey.currentState!.validate()) {
        setState(() {
          _isLoadingSaveAnswer = true;
        });
        try {
          AnswerModel answer = AnswerModel(
            sequentialEncounter: widget.encounter.sequential,
            id: widget.answer != null ? widget.answer!.id : const Uuid().v4(),
            referenceQuestion: FirebaseFirestore.instance
                .collection('answers')
                .doc(widget.question.id),
            answer: _answerTextController.text.trim(),
            hexColorCircle: selectedColorHex!,
          );
          await _answerController.saveAnswer(answer: answer);
        } catch (e) {
          CustomSnackBar.show(
            context: context,
            message: 'Erro ao salvar pergunta: $e',
            colorBar: Colors.red,
          );
        }

        setState(() {
          _isLoadingSaveAnswer = false;
        });
        Navigator.of(context).pop();
      }
    }
  }
}
