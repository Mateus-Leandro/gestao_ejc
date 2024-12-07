import 'package:flutter/material.dart';
import 'package:gestao_ejc/components/buttons/custom_delete_button.dart';
import 'package:gestao_ejc/components/forms/custom_circle_form.dart';
import 'package:gestao_ejc/components/utils/custom_list_tile.dart';
import 'package:gestao_ejc/components/utils/custom_search_row.dart';
import 'package:gestao_ejc/controllers/circle_controller.dart';
import 'package:gestao_ejc/functions/function_color.dart';
import 'package:gestao_ejc/models/circle_model.dart';
import 'package:gestao_ejc/services/auth_service.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';

class CircleScreen extends StatefulWidget {
  const CircleScreen({super.key});

  @override
  State<CircleScreen> createState() => _CircleScreenState();
}

class _CircleScreenState extends State<CircleScreen> {
  @override
  void initState() {
    _circleController.init();
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
  final FunctionColor _functionColor = getIt<FunctionColor>();
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
              circleNameController.text.trim().isEmpty
                  ? null
                  : circleNameController.text.trim(),
            ),
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

        var circles = snapshot.data!;
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
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    color: _functionColor.getFromHexadecimal(circle.colorHex),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              Text(
                circle.name,
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_authService.actualUserModel?.manipulateAdministrator ??
                  false) ...[
                Tooltip(
                  message: 'Excluir Círculo',
                  child: CustomDeleteButton(
                    alertMessage: 'Excluir Círculo',
                    deleteFunction: () async => await _circleController
                        .deleteCircle(circleId: circle.id),
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
      context: context,
      builder: (BuildContext context) {
        return const CustomCircleForm();
      },
    );
  }
}
