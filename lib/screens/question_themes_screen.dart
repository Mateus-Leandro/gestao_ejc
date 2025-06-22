import 'package:flutter/material.dart';
import 'package:gestao_ejc/components/buttons/custom_delete_button.dart';
import 'package:gestao_ejc/components/buttons/custom_edit_button.dart';
import 'package:gestao_ejc/components/forms/custom_question_theme_form.dart';
import 'package:gestao_ejc/components/utils/custom_list_tile.dart';
import 'package:gestao_ejc/components/utils/custom_search_row.dart';
import 'package:gestao_ejc/controllers/question_theme_controller.dart';
import 'package:gestao_ejc/models/encounter_model.dart';
import 'package:gestao_ejc/models/question_theme_model.dart';
import 'package:gestao_ejc/services/auth_service.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';

class QuestionThemesScreen extends StatefulWidget {
  final EncounterModel encounter;
  const QuestionThemesScreen({super.key, required this.encounter});

  @override
  State<QuestionThemesScreen> createState() => _QuestionThemesScreenState();
}

class _QuestionThemesScreenState extends State<QuestionThemesScreen> {
  TextEditingController questionThemeDescriptionController =
      TextEditingController();
  final QuestionThemeController _quetionThemeController =
      getIt<QuestionThemeController>();
  final AuthService _authService = getIt<AuthService>();

  @override
  void initState() {
    super.initState();
    _quetionThemeController.init();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomSearchRow(
            messageButton: 'Criar Tema',
            functionButton: () => _showQuestionThemeForm(null),
            showButton: true,
            inputType: TextInputType.text,
            controller: questionThemeDescriptionController,
            messageTextField: 'Pesquisar Tema',
            functionTextField: () => _quetionThemeController.filterPerson(
                themeDescription:
                    questionThemeDescriptionController.text.trim()),
            iconButton: const Icon(Icons.add),
          ),
          Expanded(child: _buildQuestionThemeList(context))
        ],
      ),
    );
  }

  Widget _buildQuestionThemeList(BuildContext context) {
    return StreamBuilder<List<QuestionThemeModel>>(
      stream: _quetionThemeController.stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
              child: Text('Erro ao carregar temas: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Nenhum tema encontrado.'));
        }

        var questionThemes = snapshot.data!;
        return ListView.builder(
          itemCount: questionThemes.length,
          itemBuilder: (context, index) {
            var theme = questionThemes[index];
            return _buildUserTile(context, theme);
          },
        );
      },
    );
  }

  Widget _buildUserTile(BuildContext context, QuestionThemeModel theme) {
    return CustomListTile(
        listTile: ListTile(
          title: Text(
            theme.description,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_authService.actualUserModel?.manipulateCircles ?? false) ...[
                Tooltip(
                  message: 'Editar Tema',
                  child: CustomEditButton(
                    form: CustomQuestionThemeForm(
                      editingQuestionTheme: theme,
                      encounter: widget.encounter,
                    ),
                  ),
                ),
                Tooltip(
                  message: 'Excluir Tema',
                  child: CustomDeleteButton(
                    deleteFunction: () =>
                        _quetionThemeController.deleteQuestionTheme(
                            questionTheme: theme,
                            sequentialEncounter: widget.encounter.sequential),
                    alertMessage:
                        'Deletar tema ${theme.description.toLowerCase()} ?',
                  ),
                ),
              ],
            ],
          ),
        ),
        defaultBackgroundColor: Colors.white);
  }

  void _showQuestionThemeForm(QuestionThemeModel? questionTheme) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomQuestionThemeForm(
          editingQuestionTheme: questionTheme,
          encounter: widget.encounter,
        );
      },
    );
  }
}
