import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gestao_ejc/components/SnackBars/custom_snack_bar.dart';
import 'package:gestao_ejc/components/buttons/custom_cancel_button.dart';
import 'package:gestao_ejc/components/buttons/custom_confirmation_button.dart';
import 'package:gestao_ejc/components/buttons/custom_pick_file_button.dart';
import 'package:gestao_ejc/components/drawers/custom_instrument_drawer.dart';
import 'package:gestao_ejc/components/forms/custom_model_form.dart';
import 'package:gestao_ejc/components/pickers/custom_date_picker.dart';
import 'package:gestao_ejc/controllers/person_controller.dart';
import 'package:gestao_ejc/enums/instrument_enum.dart';
import 'package:gestao_ejc/functions/function_pick_image.dart';
import 'package:gestao_ejc/models/abstract_person_model.dart';
import 'package:gestao_ejc/models/member_model.dart';
import 'package:gestao_ejc/models/uncle_model.dart';
import 'package:gestao_ejc/services/apis/cep_service_api.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
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
  final TextEditingController _nameController1 = TextEditingController();
  final TextEditingController _instagramController1 = TextEditingController();
  final TextEditingController _ejcAccomplishedController1 =
      TextEditingController();
  final TextEditingController _eccAccomplishedController1 =
      TextEditingController();
  final TextEditingController _birthdayDateController1 =
      TextEditingController();
  final TextEditingController _phoneController1 = TextEditingController();
  final MultiSelectController<InstrumentEnum> _instrumentController1 =
      MultiSelectController();

  final TextEditingController _nameController2 = TextEditingController();
  final TextEditingController _instagramController2 = TextEditingController();
  final TextEditingController _ejcAccomplishedController2 =
      TextEditingController();
  final TextEditingController _eccAccomplishedController2 =
      TextEditingController();
  final TextEditingController _birthdayDateController2 =
      TextEditingController();
  final TextEditingController _phoneController2 = TextEditingController();
  final MultiSelectController<InstrumentEnum> _instrumentController2 =
      MultiSelectController();

  final phoneMaskFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final cepMaskFormatter = MaskTextInputFormatter(
    mask: '##-###-###',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final _personController = getIt<PersonController>();
  final FunctionPickImage functionPickImage = getIt<FunctionPickImage>();
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _apartmentController = TextEditingController();
  final TextEditingController _numberAdressController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _referenceController = TextEditingController();
  bool memberIsUncle = false;
  bool _savingPerson = false;
  bool _isLoadingPersonImage = false;
  Uint8List? personImage;
  Uint8List? originalPersonImage;
  String? urlPersonImage = '';
  AbstractPersonModel? personOne;
  AbstractPersonModel? personTwo;
  var addressData;
  bool invalidCep = false;

  @override
  void initState() {
    super.initState();
    if (widget.editingPerson != null) {
      if (widget.editingPerson is UncleModel) {
        memberIsUncle = true;
        UncleModel uncles = widget.editingPerson as UncleModel;
        personOne = uncles.uncles[0];
        personTwo = uncles.uncles[1];
      } else {
        memberIsUncle = false;
        personOne = widget.editingPerson as MemberModel;
      }
      urlPersonImage = widget.editingPerson!.urlImage;
      fillInField();
      if (widget.editingPerson!.urlImage!.isNotEmpty) {
        _loadImages();
      }
    }
    fillInInstruments();
  }

  @override
  void dispose() {
    _nameController1.dispose();
    _instagramController1.dispose();
    _ejcAccomplishedController1.dispose();
    _eccAccomplishedController1.dispose();
    _birthdayDateController1.dispose();
    _phoneController1.dispose();

    _nameController2.dispose();
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
          CustomPickFileButton(
            onPressed: () {
              _pickPersonImage();
            },
            icon: Tooltip(
              message: 'Selecionar Imagem do ${_personType()}',
              child: Opacity(
                opacity: 1.0,
                child: Stack(
                  alignment: Alignment.topRight,
                  fit: StackFit.loose,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: _isLoadingPersonImage
                          ? const Center(child: CircularProgressIndicator())
                          : personImage != null
                              ? Image.memory(
                                  personImage!,
                                  height: 250,
                                  width: 250,
                                  fit: BoxFit.cover,
                                )
                              : Card(
                                  elevation: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        'Selecionar Imagem do ${_personType()}'),
                                  ),
                                ),
                    ),
                    if (personImage != null) ...[
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: IconButton(
                          iconSize: 35,
                          icon: const Icon(Icons.close,
                              color: Colors.red, size: 30),
                          onPressed: () {
                            setState(() {
                              personImage = null;
                            });
                          },
                          tooltip: 'Remover Imagem do membro',
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: _buildPersonForm(
                    _personType(),
                    _nameController1,
                    _phoneController1,
                    _instagramController1,
                    _ejcAccomplishedController1,
                    _eccAccomplishedController1,
                    _birthdayDateController1,
                    _instrumentController1,
                  ),
                ),
              ),
              if (memberIsUncle)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: _buildPersonForm(
                      'Tia',
                      _nameController2,
                      _phoneController2,
                      _instagramController2,
                      _ejcAccomplishedController2,
                      _eccAccomplishedController2,
                      _birthdayDateController2,
                      _instrumentController2,
                    ),
                  ),
                ),
            ],
          ),
          const Text(
            'Endereço',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(),
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            controller: _cepController,
            inputFormatters: [cepMaskFormatter],
            decoration: InputDecoration(
              labelText: "Cep",
              hintText: "00-000-000",
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () async => {
                  await _searchAdress(),
                  _formKey.currentState!.validate(),
                },
              ),
            ),
            onFieldSubmitted: (_) async => {
              await _searchAdress(),
              _formKey.currentState!.validate(),
            },
            onChanged: (_) => {
              if (cepMaskFormatter.getUnmaskedText().trim().isEmpty) ...[
                invalidCep = false,
                setState(() {
                  _clearAdressFields();
                  _formKey.currentState!.validate();
                }),
              ]
            },
            validator: (cepValue) {
              if (invalidCep || (cepValue == null || cepValue.isEmpty)) {
                return 'Cep inválido!';
              }
              return null;
            },
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                flex: 7,
                child: TextFormField(
                  readOnly: true,
                  keyboardType: TextInputType.streetAddress,
                  controller: _streetController,
                  decoration: const InputDecoration(
                    labelText: 'Rua',
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                flex: 3,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _numberAdressController,
                  decoration: const InputDecoration(
                    labelText: 'Nº',
                  ),
                ),
              ),
            ],
          ),
          TextFormField(
            keyboardType: TextInputType.text,
            controller: _referenceController,
            decoration: const InputDecoration(
              labelText: 'Referencia',
            ),
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            controller: _apartmentController,
            decoration: const InputDecoration(
              labelText: 'Apartamento',
            ),
          ),
          TextFormField(
            readOnly: true,
            keyboardType: TextInputType.text,
            controller: _districtController,
            decoration: const InputDecoration(
              labelText: 'Bairro',
            ),
          ),
          TextFormField(
            readOnly: true,
            keyboardType: TextInputType.text,
            controller: _cityController,
            decoration: const InputDecoration(
              labelText: 'Cidade',
            ),
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
    MultiSelectController<InstrumentEnum> instrumentController,
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
          inputFormatters: [phoneMaskFormatter],
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
        if (memberIsUncle) ...[
          TextFormField(
            keyboardType: TextInputType.text,
            controller: eccController,
            decoration: const InputDecoration(
              labelText: 'Ecc Realizado',
            ),
          ),
        ],
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                'Instrumentos Musicais',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            CustomInstrumentDrawer(
              instrumentController: instrumentController,
            ),
          ],
        ),
      ],
    );
  }

  String _personType() {
    return memberIsUncle ? 'Tio' : 'Membro';
  }

  Future _savePerson() async {
    await _searchAdress();
    if (_formKey.currentState!.validate()) {
      setState(() {
        _savingPerson = true;
      });

      final MemberModel uncleOrMember = MemberModel(
        id: widget.editingPerson != null
            ? widget.editingPerson!.id
            : const Uuid().v4(),
        urlImage: widget.editingPerson?.urlImage ?? '',
        name: _nameController1.text.trim(),
        type: memberIsUncle ? 'uncle' : 'member',
        birthday: _birthdayDateController1.text,
        phone: _phoneController1.text,
        instagram: _instagramController1.text.trim(),
        eccAccomplished: _ejcAccomplishedController1.text.trim(),
        ejcAccomplished: _ejcAccomplishedController1.text.trim(),
        instruments: _instrumentController1.selectedItems
            .map((instrument) => instrument.value)
            .toList(),
        cep: _cepController.text.trim(),
        street: _streetController.text.trim(),
        numberAdress: _numberAdressController.text.trim(),
        apartment: _apartmentController.text.trim(),
        city: _cityController.text.trim(),
        district: _districtController.text.trim(),
        reference: _referenceController.text.trim(),
      );

      late AbstractPersonModel finalPerson;
      try {
        if (memberIsUncle) {
          final MemberModel aunt = MemberModel(
            id: widget.editingPerson != null
                ? widget.editingPerson!.id
                : const Uuid().v4(),
            urlImage: '',
            name: _nameController2.text.trim(),
            type: 'uncle',
            birthday: _birthdayDateController2.text,
            phone: _phoneController2.text,
            instagram: _instagramController2.text.trim(),
            eccAccomplished: _ejcAccomplishedController2.text.trim(),
            ejcAccomplished: _ejcAccomplishedController2.text.trim(),
            instruments: _instrumentController2.selectedItems
                .map((instrument) => instrument.value)
                .toList(),
          );

          List<AbstractPersonModel>? uncles = [];
          uncles.add(uncleOrMember);
          uncles.add(aunt);
          final UncleModel finalUncle = UncleModel(
            id: uncleOrMember.id,
            urlImage: '',
            name:
                'Tio ${_nameController1.text.split(' ').first} e Tia ${_nameController2.text.split(' ').first}',
            uncles: uncles,
          );
          finalPerson = finalUncle;
        } else {
          finalPerson = uncleOrMember;
        }

        _personController.savePerson(person: finalPerson);

        if (personImage != originalPersonImage) {
          if (personImage != null) {
            urlPersonImage = await _personController.savePersonImage(
              image: personImage!,
              person: finalPerson,
            );
          } else {
            await _personController.removePersonImage(person: finalPerson);
            urlPersonImage = '';
          }
        }
        finalPerson.urlImage = urlPersonImage;
        await _personController.updateImage(person: finalPerson);

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
    _nameController1.text = personOne?.name ?? '';
    _instagramController1.text = personOne?.instagram ?? '';
    _ejcAccomplishedController1.text = personOne?.ejcAccomplished ?? '';
    _eccAccomplishedController1.text = personOne?.eccAccomplished ?? '';
    _birthdayDateController1.text = personOne?.birthday ?? '';
    _phoneController1.text = personOne?.phone ?? '';
    _cepController.text = personOne?.cep ?? '';
    _streetController.text = personOne?.street ?? '';
    _numberAdressController.text = personOne?.numberAdress ?? '';
    _apartmentController.text = personOne?.apartment ?? '';
    _districtController.text = personOne?.district ?? '';
    _cityController.text = personOne?.city ?? '';
    _referenceController.text = personOne?.reference ?? '';

    if (widget.editingPerson is UncleModel) {
      _nameController2.text = personTwo?.name ?? '';
      _instagramController2.text = personTwo?.instagram ?? '';
      _ejcAccomplishedController2.text = personTwo?.ejcAccomplished ?? '';
      _eccAccomplishedController2.text = personTwo?.eccAccomplished ?? '';
      _birthdayDateController2.text = personTwo?.birthday ?? '';
      _phoneController2.text = personTwo?.phone ?? '';
      _cepController.text = personTwo?.cep ?? '';
      _streetController.text = personTwo?.street ?? '';
      _numberAdressController.text = personTwo?.numberAdress ?? '';
      _apartmentController.text = personTwo?.apartment ?? '';
      _districtController.text = personTwo?.district ?? '';
      _cityController.text = personTwo?.city ?? '';
      _referenceController.text = personTwo?.reference ?? '';
    }

    if (_cepController.text.isNotEmpty) {
      _searchAdress();
      _formKey.currentState?.validate();
    }
  }

  fillInInstruments() {
    _instrumentController1.setItems(InstrumentEnum.values.map((instrument) {
      return DropdownItem(
        label: instrument.instrumentName,
        value: instrument,
        selected: personOne?.instruments?.contains(instrument) ?? false,
      );
    }).toList());

    _instrumentController2.setItems(InstrumentEnum.values.map((instrument) {
      return DropdownItem(
        label: instrument.instrumentName,
        value: instrument,
        selected: personTwo?.instruments?.contains(instrument) ?? false,
      );
    }).toList());
  }

  Future<void> _pickPersonImage() async {
    setState(() {
      _isLoadingPersonImage = true;
    });
    personImage = await functionPickImage.getSingleImage();
    personImage ??= originalPersonImage;
    setState(() {
      _isLoadingPersonImage = false;
    });
  }

  Future<void> _loadImages() async {
    setState(() {
      _isLoadingPersonImage = true;
    });
    originalPersonImage =
        await _personController.getPersonImage(person: widget.editingPerson!);

    setState(() {
      personImage = originalPersonImage;
      _isLoadingPersonImage = false;
    });
  }

  _searchAdress() async {
    addressData = null;
    var cep = cepMaskFormatter.getUnmaskedText().trim();
    try {
      if (cep.isNotEmpty) {
        addressData = await CepServiceApi.zipCodeSearch(cep);
        setState(() {
          _fillAdressFields();
          invalidCep = false;
        });
      }
    } catch (error) {
      setState(() {
        invalidCep = true;
      });
    }
  }

  _fillAdressFields() {
    _streetController.text = addressData['logradouro'] ?? '';
    _districtController.text = addressData['bairro'] ?? '';
    _cityController.text = addressData['localidade'] ?? '';
  }

  _clearAdressFields() {
    _streetController.clear();
    _numberAdressController.clear();
    _apartmentController.clear();
    _districtController.clear();
    _cityController.clear();
    _referenceController.clear();
  }
}
