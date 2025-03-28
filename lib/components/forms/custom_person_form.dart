import 'package:flutter/material.dart';
import 'package:gestao_ejc/components/forms/custom_model_form.dart';
import 'package:gestao_ejc/components/pickers/custom_date_picker.dart';
import 'package:gestao_ejc/models/abstract_person_model.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CustomPersonForm extends StatefulWidget {
  final AbstractPersonModel? editingPerson;
  const CustomPersonForm({
    super.key,
    required this.editingPerson,
  });

  @override
  State<CustomPersonForm> createState() => _CustomPersonFormState();
}

class _CustomPersonFormState extends State<CustomPersonForm> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _memberNameController = TextEditingController();
  final TextEditingController _instagramController = TextEditingController();
  final TextEditingController _initialEncounterDateController =
      TextEditingController();
  final maskFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );
  bool memberIsUncle = false;

  @override
  Widget build(BuildContext context) {
    return CustomModelForm(
      title: widget.editingPerson != null
          ? 'Editar ${_personType()}'
          : 'Criar ${_personType()}',
      formKey: formKey,
      formBody: _buildFormBody(),
      actions: [],
    );
  }

  _buildFormBody() {
    return [
      Row(
        children: [
          Checkbox(
              value: memberIsUncle,
              onChanged: (value) {
                setState(() {
                  memberIsUncle = value!;
                });
              }),
          const Text('Membro é Tio?'),
        ],
      ),
      Padding(
        padding: const EdgeInsets.all(8),
        child: _buildPersonForm(),
      )
    ];
  }

  _buildPersonForm() {
    return Column(
      children: [
        TextFormField(
          keyboardType: TextInputType.name,
          controller: _memberNameController,
          decoration: InputDecoration(
            labelText: 'Nome do ${_personType()}',
          ),
          validator: (personName) {
            if (personName == null || personName.isEmpty) {
              return 'Necessario informar o nome do ${_personType()}';
            }
            return null;
          },
        ),
        TextFormField(
          keyboardType: TextInputType.phone,
          inputFormatters: [maskFormatter],
          decoration: const InputDecoration(
            labelText: "Telefone",
            hintText: "(99) 99999-9999",
          ),
        ),
        TextFormField(
          controller: _instagramController,
          decoration: const InputDecoration(
            labelText: 'Instagram',
          ),
        ),
        CustomDatePicker(
          controller: _initialEncounterDateController,
          labelText: 'Data de nascimento',
          active: true,
        ),
        TextFormField(
          controller: _instagramController,
          decoration: const InputDecoration(
            labelText: 'Instagram',
          ),
        ),
      ],
    );
  }

  String _personType() {
    return memberIsUncle ? 'tio' : 'membro';
  }
}
