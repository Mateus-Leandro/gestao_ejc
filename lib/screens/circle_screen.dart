import 'package:flutter/material.dart';
import 'package:gestao_ejc/components/SnackBars/custom_snack_bar.dart';
import 'package:gestao_ejc/components/buttons/custom_delete_button.dart';
import 'package:gestao_ejc/components/buttons/custom_edit_button.dart';
import 'package:gestao_ejc/components/forms/custom_circle_form.dart';
import 'package:gestao_ejc/components/utils/custom_list_tile.dart';
import 'package:gestao_ejc/components/utils/custom_search_row.dart';
import 'package:gestao_ejc/controllers/circle_controller.dart';
import 'package:gestao_ejc/enums/circle_color_enum.dart';
import 'package:gestao_ejc/models/circle_model.dart';
import 'package:gestao_ejc/models/encounter_model.dart';
import 'package:gestao_ejc/services/auth_service.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';

class CircleScreen extends StatefulWidget {
  final EncounterModel encounter;
  const CircleScreen({super.key, required this.encounter});

  @override
  State<CircleScreen> createState() => _CircleScreenState();
}

class _CircleScreenState extends State<CircleScreen> {
  @override
  void initState() {
    _circleController.init(sequentialEncounter: widget.encounter.sequential);
    super.initState();
  }

  @override
  void dispose() {
    _circleController.dispose();
    super.dispose();
  }

  TextEditingController circleNameController = TextEditingController();
  final CircleController _circleController = getIt<CircleController>();
  final AuthService _authService = getIt<AuthService>();
  List<CircleModel> circles = [];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomSearchRow(
            messageButton: 'Criar Circulo',
            functionButton: () => _showCircleForm(null),
            showButton: true,
            inputType: TextInputType.text,
            controller: circleNameController,
            messageTextField: 'Pesquisar Círculo',
            functionTextField: () => _circleController.getCircles(
                circleName: circleNameController.text.trim().isEmpty
                    ? null
                    : circleNameController.text.trim(),
                sequentialEncounter: widget.encounter.sequential),
            iconButton: const Icon(Icons.add),
          ),
          Expanded(child: _buildCircleList(context))
        ],
      ),
    );
  }

  Widget _buildCircleList(BuildContext context) {
    return StreamBuilder<List<CircleModel>>(
      stream: _circleController.stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Erro ao carregar círculos: ${snapshot.error}'),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Nenhum círculo encontrado.'));
        }

        circles = snapshot.data!;
        return ListView.builder(
          itemCount: circles.length,
          itemBuilder: (context, index) {
            var circle = circles[index];
            return _buildCircleTile(context, circle);
          },
        );
      },
    );
  }

  Widget _buildCircleTile(BuildContext context, CircleModel circle) {
    return CustomListTile(
        listTile: ListTile(
          title: Row(children: [
            circle.color.iconColor,
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                circle.color.circleName,
              ),
            ),
          ]),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_authService.actualUserModel?.manipulateAdministrator ??
                  false) ...[
                Tooltip(
                  message: 'Editar Círculo',
                  child: CustomEditButton(
                    form: CustomCircleForm(
                      encounter: widget.encounter,
                      editingCircle: circle,
                      circles: circles,
                    ),
                  ),
                ),
                Tooltip(
                  message: 'Excluir Círculo',
                  child: CustomDeleteButton(
                    alertMessage: 'Excluir Círculo',
                    deleteFunction: () async => _deleteCircle(circle: circle),
                  ),
                ),
              ],
            ],
          ),
        ),
        defaultBackgroundColor: Colors.white);
  }

  void _showCircleForm(CircleModel? circleModel) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return CustomCircleForm(
          encounter: widget.encounter,
          circles: circles,
        );
      },
    );
  }

  Future<void> _deleteCircle({required CircleModel circle}) async {
    try {
      await _circleController.deleteCircle(circle: circle);
    } catch (e) {
      CustomSnackBar.show(
        context: context,
        message: 'Erro ao excluir círculo: $e',
        colorBar: Colors.red,
      );
    }
  }
}
