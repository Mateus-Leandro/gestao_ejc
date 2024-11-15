import 'package:flutter/material.dart';
import 'package:gestao_ejc/components/buttons/custom_delete_button.dart';
import 'package:gestao_ejc/components/buttons/custom_edit_button.dart';
import 'package:gestao_ejc/components/utils/custom_list_tile.dart';
import 'package:gestao_ejc/components/utils/custom_search_row.dart';
import 'package:gestao_ejc/controllers/circle_controller.dart';
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

  TextEditingController circleController = TextEditingController();
  final CircleController _circleController = getIt<CircleController>();
  final AuthService _authService = getIt<AuthService>();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomSearchRow(
            messageButton: 'Criar Circulo',
            functionButton: () {},
            showButton: true,
            inputType: TextInputType.text,
            controller: circleController,
            messageTextField: 'Pesquisar Círculo',
            functionTextField: () {},
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
              Text(
                circle.name,
                style: TextStyle(
                  color: Color(
                    int.parse(circle.colorHex.replaceFirst('#', '0xff')),
                  ),
                ),
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  'Membros - Mín: ${circle.minMembers} Máx: ${circle.maxMembers} '),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_authService.actualUserModel?.manipulateAdministrator ??
                  false) ...[
                Tooltip(
                  message: 'Editar Círculo',
                  child: CustomEditButton(form: Container()),
                ),
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
}
