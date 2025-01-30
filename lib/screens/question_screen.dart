import 'package:flutter/material.dart';
import 'package:gestao_ejc/components/SnackBars/custom_snack_bar.dart';
import 'package:gestao_ejc/components/buttons/custom_delete_button.dart';
import 'package:gestao_ejc/components/buttons/custom_edit_button.dart';
import 'package:gestao_ejc/components/forms/custom_question_form.dart';
import 'package:gestao_ejc/components/utils/custom_list_tile.dart';
import 'package:gestao_ejc/components/utils/custom_search_row.dart';
import 'package:gestao_ejc/controllers/answer_controller.dart';
import 'package:gestao_ejc/controllers/question_controller.dart';
import 'package:gestao_ejc/functions/function_color.dart';
import 'package:gestao_ejc/models/answer_model.dart';
import 'package:gestao_ejc/models/encounter_model.dart';
import 'package:gestao_ejc/models/question_model.dart';
import 'package:gestao_ejc/services/auth_service.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';

class QuestionScreen extends StatefulWidget {
  final EncounterModel encounter;
  const QuestionScreen({super.key, required this.encounter});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  @override
  void initState() {
    _questionController.init(sequentialEncounter: widget.encounter.sequential);
    _loadAnswers();
    super.initState();
  }

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  final QuestionController _questionController = getIt<QuestionController>();
  final AnswerController _answerController = getIt<AnswerController>();
  TextEditingController questionTextController = TextEditingController();
  final AuthService _authService = getIt<AuthService>();
  List<QuestionModel> questions = [];
  List<AnswerModel> answers = [];
  bool isLoadingAnswers = true;
  FunctionColor _functionColor = getIt<FunctionColor>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomSearchRow(
            messageButton: 'Criar Pergunta',
            functionButton: () =>
                _showQuestionForm(encounter: widget.encounter),
            showButton: true,
            inputType: TextInputType.text,
            controller: questionTextController,
            messageTextField: 'Pesquisar Pergunta',
            functionTextField: () => (),
            iconButton: const Icon(Icons.add),
          ),
          Expanded(child: _buildQuestionList(context))
        ],
      ),
    );
  }

  Widget _buildQuestionList(BuildContext context) {
    return StreamBuilder<List<QuestionModel>>(
      stream: _questionController.stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Erro ao carregar perguntas: ${snapshot.error}'),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Nenhuma pergunta encontrada.'));
        }

        questions = snapshot.data!;
        return ListView.builder(
          itemCount: questions.length,
          itemBuilder: (context, index) {
            var question = questions[index];
            return _buildQuestionTile(context, question, index);
          },
        );
      },
    );
  }

  Widget _buildQuestionTile(
      BuildContext context, QuestionModel question, int index) {
    return CustomListTile(
        listTile: ListTile(
          title: Row(
            children: [
              Flexible(
                child: Text(
                  question.question,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isLoadingAnswers) ...[
                const Center(
                  child: CircularProgressIndicator(),
                )
              ] else ...[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Tooltip(
                        message: 'Responder pergunta',
                        child: IconButton(
                            onPressed: () {}, icon: const Icon(Icons.help)),
                      ),
                    ),
                    Tooltip(
                      message: 'Editar Pergunta',
                      child: CustomEditButton(
                        form: CustomQuestionForm(
                          encounter: widget.encounter,
                          editingQuestion: question,
                        ),
                      ),
                    ),
                    Tooltip(
                      message: 'Excluir Pergunta',
                      child: CustomDeleteButton(
                        alertMessage: 'Excluir Pergunta',
                        deleteFunction: () async =>
                            _deleteQuestion(question: question),
                      ),
                    ),
                  ],
                ),
                for (var answer in answers) ...[
                  if (answer.referenceQuestion.id == question.id) ...[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 20,
                            width: 20,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              color: _functionColor
                                  .getFromHexadecimal(answer.hexColorCircle),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          Flexible(
                              child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(answer.answer),
                          )),
                          Tooltip(
                            message: 'Editar Resposta',
                            child: IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.edit_note)),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      height: 3,
                    )
                  ]
                ],
              ],
            ],
          ),
        ),
        defaultBackgroundColor: Colors.white);
  }

  Future<void> _deleteQuestion({required QuestionModel question}) async {
    try {
      await _questionController.deleteQuestion(question: question);
    } catch (e) {
      CustomSnackBar.show(
        context: context,
        message: 'Erro ao excluir pergunta',
        colorBar: Colors.red,
      );
    }
  }

  void _showQuestionForm(
      {required EncounterModel encounter, QuestionModel? question}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomQuestionForm(
            encounter: encounter, editingQuestion: question);
      },
    );
  }

  void _loadAnswers() async {
    setState(() {
      isLoadingAnswers = true;
    });
    answers = await _answerController.init(
      sequentialEncounter: widget.encounter.sequential,
    );
    setState(() {
      isLoadingAnswers = false;
    });
  }
}
