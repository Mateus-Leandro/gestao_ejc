import 'package:flutter/material.dart';
import 'package:gestao_ejc/components/SnackBars/custom_snack_bar.dart';
import 'package:gestao_ejc/components/buttons/custom_delete_button.dart';
import 'package:gestao_ejc/components/utils/custom_list_tile.dart';
import 'package:gestao_ejc/components/utils/custom_search_row.dart';
import 'package:gestao_ejc/controllers/question_controller.dart';
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
    super.initState();
  }

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  final QuestionController _questionController = getIt<QuestionController>();
  TextEditingController questionTextController = TextEditingController();
  final AuthService _authService = getIt<AuthService>();
  List<QuestionModel> questions = [];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomSearchRow(
            messageButton: 'Criar Pergunta',
            functionButton: () => (),
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
            return _buildQuestionTile(context, question);
          },
        );
      },
    );
  }

  Widget _buildQuestionTile(BuildContext context, QuestionModel question) {
    return CustomListTile(
        listTile: ListTile(
          title: Row(
            children: [
              Text(
                question.question,
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_authService.actualUserModel?.manipulateAdministrator ??
                  false) ...[
                Tooltip(
                  message: 'Excluir Pergunta',
                  child: CustomDeleteButton(
                    alertMessage: 'Excluir Pergunta',
                    deleteFunction: () async =>
                        _deleteQuestion(question: question),
                  ),
                ),
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
}
