import 'package:flutter/material.dart';
import 'package:gestao_ejc/components/SnackBars/custom_snack_bar.dart';
import 'package:gestao_ejc/components/buttons/custom_cancel_button.dart';
import 'package:gestao_ejc/components/buttons/custom_confirmation_button.dart';
import 'package:gestao_ejc/components/forms/custom_model_form.dart';
import 'package:gestao_ejc/components/pickers/custom_date_picker.dart';
import 'package:gestao_ejc/controllers/person_controller.dart';
import 'package:gestao_ejc/models/abstract_person_model.dart';
import 'package:gestao_ejc/models/member_model.dart';
import 'package:gestao_ejc/models/uncle_model.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:uuid/uuid.dart';

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
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _NameController1 = TextEditingController();
  final TextEditingController _instagramController1 = TextEditingController();
  final TextEditingController _ejcAccomplishedController1 =
      TextEditingController();
  final TextEditingController _eccAccomplishedController1 =
      TextEditingController();
  final TextEditingController _birthdayDateController1 =
      TextEditingController();
  final TextEditingController _phoneController1 = TextEditingController();

  final TextEditingController _NameController2 = TextEditingController();
  final TextEditingController _instagramController2 = TextEditingController();
  final TextEditingController _ejcAccomplishedController2 =
      TextEditingController();
  final TextEditingController _eccAccomplishedController2 =
      TextEditingController();
  final TextEditingController _birthdayDateController2 =
      TextEditingController();
  final TextEditingController _phoneController2 = TextEditingController();

  final maskFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final _personController = getIt<PersonController>();
  bool memberIsUncle = false;
  bool _savingPerson = false;
  AbstractPersonModel? personOne;
  AbstractPersonModel? personTwo;

  @override
  void initState() {
    super.initState();
    if (widget.editingPerson != null) {
      if (widget.editingPerson is UncleModel) {
        UncleModel uncles = widget.editingPerson as UncleModel;
        personOne = uncles.uncles[0];
        personTwo = uncles.uncles[0];
      } else {
        personOne = widget.editingPerson as MemberModel;
      }
      fillInField();
    }
  }

  @override
  void dispose() {
    _NameController1.dispose();
    _instagramController1.dispose();
    _ejcAccomplishedController1.dispose();
    _eccAccomplishedController1.dispose();
    _birthdayDateController1.dispose();
    _phoneController1.dispose();

    _NameController2.dispose();
    _instagramController2.dispose();
    _ejcAccomplishedController2.dispose();
    _eccAccomplishedController2.dispose();
    _birthdayDateController2.dispose();
    _phoneController2.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomModelForm(
      title: widget.editingPerson != null
          ? 'Editar ${_personType()}'
          : 'Criar ${_personType()}',
      formKey: _formKey,
      formBody: _buildFormBody(),
      actions: _savingPerson
          ? [
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: CircularProgressIndicator(),
                ),
              )
            ]
          : [
              CustomCancelButton(onPressed: () => Navigator.of(context).pop()),
              CustomConfirmationButton(onPressed: () => _savePerson())
            ],
    );
  }

  List<Widget> _buildFormBody() {
    return [
      Column(
        children: [
          Row(
            children: [
              Checkbox(
                value: memberIsUncle,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      memberIsUncle = value;
                    });
                  }
                },
              ),
              const Text('É Tio?'),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: _buildPersonForm(
                    _personType(),
                    _NameController1,
                    _phoneController1,
                    _instagramController1,
                    _ejcAccomplishedController1,
                    _eccAccomplishedController1,
                    _birthdayDateController1,
                  ),
                ),
              ),
              if (memberIsUncle)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: _buildPersonForm(
                      'Tia',
                      _NameController2,
                      _phoneController2,
                      _instagramController2,
                      _ejcAccomplishedController2,
                      _eccAccomplishedController2,
                      _birthdayDateController2,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    ];
  }

  Widget _buildPersonForm(
    String titleForm,
    TextEditingController nameController,
    TextEditingController phoneController,
    TextEditingController instagramController,
    TextEditingController ejcController,
    TextEditingController eccController,
    TextEditingController dateController,
  ) {
    return Column(
      children: [
        Text(
          titleForm,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Divider(),
        ),
        TextFormField(
          keyboardType: TextInputType.name,
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Nome',
          ),
          validator: (personName) {
            if (personName == null || personName.isEmpty) {
              return 'Necessário informar o nome do ${_personType()}';
            }
            return null;
          },
        ),
        TextFormField(
          keyboardType: TextInputType.phone,
          controller: phoneController,
          inputFormatters: [maskFormatter],
          decoration: const InputDecoration(
            labelText: "Telefone",
            hintText: "(99) 99999-9999",
          ),
        ),
        TextFormField(
          keyboardType: TextInputType.text,
          controller: instagramController,
          decoration: const InputDecoration(
            labelText: 'Instagram',
          ),
        ),
        CustomDatePicker(
          controller: dateController,
          labelText: 'Data de nascimento',
          active: true,
        ),
        TextFormField(
          keyboardType: TextInputType.text,
          controller: ejcController,
          decoration: const InputDecoration(
            labelText: 'Ejc Realizado',
          ),
        ),
        TextFormField(
          keyboardType: TextInputType.text,
          controller: eccController,
          decoration: const InputDecoration(
            labelText: 'Ecc Realizado',
          ),
        ),
      ],
    );
  }

  String _personType() {
    return memberIsUncle ? 'Tio' : 'Membro';
  }

  Future _savePerson() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _savingPerson = true;
      });
      final MemberModel uncleOrMember = MemberModel(
        id: widget.editingPerson != null
            ? widget.editingPerson!.id
            : const Uuid().v4(),
        name: _NameController1.text.trim(),
        type: memberIsUncle ? 'uncle' : 'member',
        birthday: _birthdayDateController1.text,
        phone: _phoneController1.text,
        instagram: _instagramController1.text.trim(),
        eccAccomplished: _ejcAccomplishedController1.text.trim(),
        ejcAccomplished: _ejcAccomplishedController1.text.trim(),
      );
      final MemberModel aunt = MemberModel(
        id: widget.editingPerson != null
            ? widget.editingPerson!.id
            : const Uuid().v4(),
        name: _NameController2.text.trim(),
        type: 'Uncle',
        birthday: _birthdayDateController2.text,
        phone: _phoneController2.text,
        instagram: _instagramController2.text.trim(),
        eccAccomplished: _ejcAccomplishedController2.text.trim(),
        ejcAccomplished: _ejcAccomplishedController2.text.trim(),
      );

      try {
        if (memberIsUncle) {
          List<AbstractPersonModel>? uncles = [];
          uncles.add(uncleOrMember);
          uncles.add(aunt);
          final UncleModel finalUncle = UncleModel(
            id: uncleOrMember.id,
            name:
                'Tio ${_NameController1.text.split(' ').first} e Tia ${_NameController2.text.split(' ').first}',
            uncles: uncles,
          );
          _personController.savePerson(person: finalUncle);
        } else {
          _personController.savePerson(person: uncleOrMember);
        }
        CustomSnackBar.show(
          context: context,
          message:
              '${memberIsUncle ? 'Tios salvos' : 'Membro salvo'} com sucesso!',
          colorBar: Colors.green,
        );
      } catch (e) {
        CustomSnackBar.show(
          context: context,
          message: e.toString(),
          colorBar: Colors.red,
        );
      } finally {
        Navigator.of(context).pop();
      }

      setState(() {
        _savingPerson = false;
      });
    }
  }

  fillInField() {
    _NameController1.text = personOne!.name;
    _instagramController1.text = personOne!.instagram ?? '';
    _ejcAccomplishedController1.text = personOne!.ejcAccomplished ?? '';
    _eccAccomplishedController1.text = personOne!.eccAccomplished ?? '';
    _birthdayDateController1.text = personOne!.birthday!;
    _phoneController1.text = personOne!.phone ?? '';

    if (widget.editingPerson is UncleModel) {
      _NameController2.text = personTwo!.name;
      _instagramController2.text = personTwo!.instagram ?? '';
      _ejcAccomplishedController2.text = personTwo!.ejcAccomplished ?? '';
      _eccAccomplishedController2.text = personTwo!.eccAccomplished ?? '';
      _birthdayDateController2.text = personTwo!.birthday!;
      _phoneController2.text = personTwo!.phone ?? '';
    }
  }
}
