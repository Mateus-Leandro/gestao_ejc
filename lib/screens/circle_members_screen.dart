import 'package:flutter/material.dart';
import 'package:gestao_ejc/components/utils/custom_list_tile.dart';
import 'package:gestao_ejc/components/utils/custom_search_row.dart';
import 'package:gestao_ejc/controllers/circle_member_controller.dart';
import 'package:gestao_ejc/controllers/member_controller.dart';
import 'package:gestao_ejc/functions/function_color.dart';
import 'package:gestao_ejc/models/circle_member_model.dart';
import 'package:gestao_ejc/models/member_model.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';

class CircleMembersScreen extends StatefulWidget {
  const CircleMembersScreen({super.key});

  @override
  State<CircleMembersScreen> createState() => _CircleMembersScreenState();
}

class _CircleMembersScreenState extends State<CircleMembersScreen> {
  @override
  void initState() {
    _circleMemberController.init();
    _getMembers();
    super.initState();
  }

  @override
  void dispose() {
    _circleMemberController.dispose();
    super.dispose();
  }

  final CircleMemberController _circleMemberController =
      getIt<CircleMemberController>();
  final TextEditingController memberNameController = TextEditingController();
  final FunctionColor _functionColor = getIt<FunctionColor>();
  final MemberController _memberController = getIt<MemberController>();
  bool loadingMembers = true;
  List<MemberModel> members = [];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomSearchRow(
            messageButton: 'Adicionar Membro',
            functionButton: () => (),
            showButton: true,
            inputType: TextInputType.text,
            controller: memberNameController,
            messageTextField: 'Pesquisar membro',
            functionTextField: () => (),
            iconButton: const Icon(Icons.add),
          ),
          Expanded(child: _buildCircleMembersList(context)),
        ],
      ),
    );
  }

  Widget _buildCircleMembersList(BuildContext context) {
    if (loadingMembers) {
      return const Center(child: CircularProgressIndicator());
    }

    return StreamBuilder(
        stream: _circleMemberController.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                  'Erro ao carregar membros dos círculos: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum membro encontrado'));
          }

          var circleMembers = snapshot.data!;

          return ListView.builder(
            itemCount: circleMembers.length,
            itemBuilder: (context, index) {
              var member = circleMembers[index];
              return _builCircleTile(context, member);
            },
          );
        });
  }

  Widget _builCircleTile(BuildContext context, CircleMemberModel circleMember) {
    MemberModel? memberReference = members
        .firstWhere((element) => element.id == circleMember.idCircleMember);
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
                    color: _functionColor
                        .getFromHexadecimal(circleMember.hexColorCircle),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      memberReference.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      circleMember.type,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        defaultBackgroundColor: Colors.white);
  }

  void _getMembers() async {
    members = await _memberController.getMembers();
    setState(() {
      loadingMembers = false;
    });
  }
}
