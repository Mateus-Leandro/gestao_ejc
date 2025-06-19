import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gestao_ejc/components/SnackBars/custom_snack_bar.dart';
import 'package:gestao_ejc/components/buttons/custom_cancel_button.dart';
import 'package:gestao_ejc/components/buttons/custom_confirmation_button.dart';
import 'package:gestao_ejc/components/buttons/custom_pick_file_button.dart';
import 'package:gestao_ejc/components/forms/custom_model_form.dart';
import 'package:gestao_ejc/controllers/speaker_controller.dart';
import 'package:gestao_ejc/functions/function_pick_image.dart';
import 'package:gestao_ejc/models/speaker_couple_model.dart';
import 'package:gestao_ejc/models/speaker_model.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:uuid/uuid.dart';

class CustomSpeakerForm extends StatefulWidget {
  final AbstractSpeakerModel? editingSpeaker;

  const CustomSpeakerForm({
    super.key,
    required this.editingSpeaker,
  });

  @override
  State<CustomSpeakerForm> createState() => _CustomSpeakerFormState();
}

class _CustomSpeakerFormState extends State<CustomSpeakerForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController1 = TextEditingController();
  final TextEditingController _phoneController1 = TextEditingController();
  final TextEditingController _instagramController1 = TextEditingController();

  final TextEditingController _nameController2 = TextEditingController();
  final TextEditingController _phoneController2 = TextEditingController();
  final TextEditingController _instagramController2 = TextEditingController();

  final phoneMaskFormatter = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final _speakerController = getIt<SpeakerController>();
  final FunctionPickImage functionPickImage = getIt<FunctionPickImage>();
  bool speakerIsCouple = false;
  bool _savingSpeaker = false;
  bool _isLoadingSpeakerImage1 = false;
  bool _isLoadingSpeakerImage2 = false;
  Uint8List? speakerImage1;
  Uint8List? speakerImage2;
  Uint8List? originalSpeakerImage1;
  Uint8List? originalSpeakerImage2;
  String? urlSpeakerImage1 = '';
  String? urlSpeakerImage2 = '';

  @override
  void initState() {
    super.initState();
    if (widget.editingSpeaker != null) {
      if (widget.editingSpeaker is SpeakerCoupleModel) {
        speakerIsCouple = true;
        var coupleModel = widget.editingSpeaker as SpeakerCoupleModel;

        var uncle = coupleModel.uncle;
        var aunt = coupleModel.aunt;

        _nameController1.text = uncle.name;
        _phoneController1.text = uncle.phone ?? '';
        _instagramController1.text = uncle.instagram ?? '';

        _nameController2.text = aunt.name;
        _phoneController2.text = aunt.phone ?? '';
        _instagramController2.text = aunt.instagram ?? '';

        urlSpeakerImage1 = uncle.urlImage;
        urlSpeakerImage2 = aunt.urlImage;
      } else {
        speakerIsCouple = false;
        var speakerModel = widget.editingSpeaker as SpeakerModel;
        _nameController1.text = speakerModel.name;
        _phoneController1.text = speakerModel.phone ?? '';
        _instagramController1.text = speakerModel.instagram ?? '';

        urlSpeakerImage1 = speakerModel.urlImage;
      }

      _loadImages();
    }
  }

  @override
  void dispose() {
    _nameController1.dispose();
    _phoneController1.dispose();
    _instagramController1.dispose();
    _nameController2.dispose();
    _phoneController2.dispose();
    _instagramController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomModelForm(
      title: widget.editingSpeaker != null
          ? 'Editar ${_speakerType()}'
          : 'Criar ${_speakerType()}',
      formKey: _formKey,
      formBody: _buildFormBody(),
      actions: _savingSpeaker
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
              CustomConfirmationButton(onPressed: () => _saveSpeaker())
            ],
    );
  }

  List<Widget> _buildFormBody() {
    // Verificar o tamanho da tela para decidir o layout
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = screenWidth < 600;

    return [
      SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Checkbox(
                  value: speakerIsCouple,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        speakerIsCouple = value;
                      });
                    }
                  },
                ),
                const Text('É tio?'),
              ],
            ),
            // Layout responsivo para os dados dos palestrantes
            isSmallScreen
                ? _buildSpeakerSectionsVertical()
                : _buildSpeakerSectionsHorizontal(),
            const SizedBox(height: 16),
            // Seção de endereço
          ],
        ),
      ),
    ];
  }

  // Layout vertical para telas pequenas
  Widget _buildSpeakerSectionsVertical() {
    return Column(
      children: [
        // Primeiro palestrante
        _buildSpeakerSection(
          _speakerType(),
          _nameController1,
          _phoneController1,
          _instagramController1,
          1,
        ),
        const SizedBox(height: 16),
        // Segundo palestrante (se for casal)
        if (speakerIsCouple) ...[
          _buildSpeakerSection(
            'Tia',
            _nameController2,
            _phoneController2,
            _instagramController2,
            2,
          ),
          const SizedBox(height: 16),
        ],
      ],
    );
  }

  // Layout horizontal para telas maiores
  Widget _buildSpeakerSectionsHorizontal() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Primeiro palestrante
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: _buildSpeakerSection(
              _speakerType(),
              _nameController1,
              _phoneController1,
              _instagramController1,
              1,
            ),
          ),
        ),
        // Segundo palestrante (se for casal)
        if (speakerIsCouple)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: _buildSpeakerSection(
                'Tia',
                _nameController2,
                _phoneController2,
                _instagramController2,
                2,
              ),
            ),
          ),
      ],
    );
  }

  // Seção individual de cada palestrante
  Widget _buildSpeakerSection(
    String titleForm,
    TextEditingController nameController,
    TextEditingController phoneController,
    TextEditingController instagramController,
    int speakerIndex,
  ) {
    // Determina qual imagem e estado de carregamento usar
    Uint8List? speakerImage = speakerIndex == 1 ? speakerImage1 : speakerImage2;
    bool isLoadingSpeakerImage =
        speakerIndex == 1 ? _isLoadingSpeakerImage1 : _isLoadingSpeakerImage2;

    // Tamanho da tela para dimensionar componentes
    double screenWidth = MediaQuery.of(context).size.width;
    double imageSize = screenWidth < 600 ? 120 : 150;

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
          validator: (speakerName) {
            if (speakerName == null || speakerName.isEmpty) {
              return 'Necessário informar o nome do $titleForm';
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
          validator: (phoneNumber) {
            if (phoneNumber == null || phoneNumber.isEmpty) {
              return 'Necessário informar o telefone do $titleForm';
            }
            return null;
          },
        ),
        TextFormField(
          keyboardType: TextInputType.url,
          controller: instagramController,
          decoration: const InputDecoration(
            labelText: "Instagram",
            hintText: "@username",
          ),
        ),
        const SizedBox(height: 16),
        // Botão para selecionar imagem
        CustomPickFileButton(
          onPressed: () {
            speakerIndex == 1 ? _pickSpeakerImage1() : _pickSpeakerImage2();
          },
          icon: Tooltip(
            message: 'Selecionar Imagem do $titleForm',
            child: Opacity(
              opacity: 1.0,
              child: Stack(
                alignment: Alignment.topRight,
                fit: StackFit.loose,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: isLoadingSpeakerImage
                        ? const Center(child: CircularProgressIndicator())
                        : speakerImage != null
                            ? Image.memory(
                                speakerImage,
                                height: imageSize,
                                width: imageSize,
                                fit: BoxFit.cover,
                              )
                            : Card(
                                elevation: 5,
                                child: SizedBox(
                                  height: imageSize,
                                  width: imageSize,
                                  child: Center(
                                    child: Text(
                                      'Selecionar Imagem do $titleForm',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                  ),
                  if (speakerImage != null) ...[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        iconSize: 25,
                        icon: const Icon(Icons.close,
                            color: Colors.red, size: 20),
                        onPressed: () {
                          setState(() {
                            if (speakerIndex == 1) {
                              speakerImage1 = null;
                            } else {
                              speakerImage2 = null;
                            }
                          });
                        },
                        tooltip: 'Remover Imagem do $titleForm',
                      ),
                    ),
                  ]
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _speakerType() {
    return speakerIsCouple ? 'Tio' : 'Palestrante';
  }

  Future _saveSpeaker() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _savingSpeaker = true;
      });

      String speakerId = widget.editingSpeaker != null
          ? widget.editingSpeaker!.id
          : const Uuid().v4();

      try {
        // Salvar imagens
        if (speakerImage1 != null && speakerImage1 != originalSpeakerImage1) {
          urlSpeakerImage1 = await _speakerController.saveSpeakerImage(
            image: speakerImage1!,
            speakerId: speakerId,
            path: speakerIsCouple ? 'uncle.png' : 'speaker.png',
          );
        } else if (speakerImage1 == null && originalSpeakerImage1 != null) {
          await _speakerController.removeSpeakerImage(
            speakerId: speakerId,
            path: speakerIsCouple ? 'uncle.png' : 'speaker.png',
          );
          urlSpeakerImage1 = '';
        }

        if (speakerIsCouple &&
            speakerImage2 != null &&
            speakerImage2 != originalSpeakerImage2) {
          urlSpeakerImage2 = await _speakerController.saveSpeakerImage(
            image: speakerImage2!,
            speakerId: speakerId,
            path: 'aunt.png',
          );
        } else if (speakerIsCouple &&
            speakerImage2 == null &&
            originalSpeakerImage2 != null) {
          await _speakerController.removeSpeakerImage(
            speakerId: speakerId,
            path: 'aunt.png',
          );
          urlSpeakerImage2 = '';
        }

        // Cria o modelo apropriado
        late AbstractSpeakerModel finalSpeaker;

        if (speakerIsCouple) {
          // Cria o array de palestrantes (uncles)
          List<SpeakerModel> uncles = [
            // Tio
            SpeakerModel(
              id: speakerId,
              urlImage: urlSpeakerImage1,
              name: _nameController1.text.trim(),
              type: 'uncle',
              phone: _phoneController1.text,
              instagram: _instagramController1.text,
            ),
            // Tia
            SpeakerModel(
              id: speakerId,
              urlImage: urlSpeakerImage2,
              name: _nameController2.text.trim(),
              type: 'aunt',
              phone: _phoneController2.text,
              instagram: _instagramController2.text,
            ),
          ];

          // Cria o modelo do casal
          finalSpeaker = SpeakerCoupleModel(
            id: speakerId,
            urlImage: '',
            name:
                'Tio ${_nameController1.text.split(' ').first} e Tia ${_nameController2.text.split(' ').first}',
            uncles: uncles,
          );
        } else {
          finalSpeaker = SpeakerModel(
            id: speakerId,
            urlImage: urlSpeakerImage1,
            name: _nameController1.text.trim(),
            type: 'speaker',
            phone: _phoneController1.text,
            instagram: _instagramController1.text,
          );
        }

        // Salva o palestrante no banco de dados
        await _speakerController.saveSpeaker(speaker: finalSpeaker);

        CustomSnackBar.show(
          context: context,
          message:
              '${speakerIsCouple ? 'Tios palestrantes' : 'Palestrante'} salvo com sucesso!',
          colorBar: Colors.green,
        );

        Navigator.of(context).pop();
      } catch (e) {
        CustomSnackBar.show(
          context: context,
          message: e.toString(),
          colorBar: Colors.red,
        );
      } finally {
        setState(() {
          _savingSpeaker = false;
        });
      }
    }
  }

  Future<void> _pickSpeakerImage1() async {
    setState(() {
      _isLoadingSpeakerImage1 = true;
    });
    speakerImage1 = await functionPickImage.getSingleImage();
    speakerImage1 ??= originalSpeakerImage1;
    setState(() {
      _isLoadingSpeakerImage1 = false;
    });
  }

  Future<void> _pickSpeakerImage2() async {
    setState(() {
      _isLoadingSpeakerImage2 = true;
    });
    speakerImage2 = await functionPickImage.getSingleImage();
    speakerImage2 ??= originalSpeakerImage2;
    setState(() {
      _isLoadingSpeakerImage2 = false;
    });
  }

  Future<void> _loadImages() async {
    if (widget.editingSpeaker == null) return;

    if (widget.editingSpeaker is SpeakerCoupleModel) {
      setState(() {
        _isLoadingSpeakerImage1 = true;
        _isLoadingSpeakerImage2 = true;
      });

      // Carrega imagem do tio
      if (urlSpeakerImage1 != null && urlSpeakerImage1!.isNotEmpty) {
        try {
          originalSpeakerImage1 = await _speakerController.getSpeakerImage(
              speakerId: widget.editingSpeaker!.id, path: 'uncle.png');
          speakerImage1 = originalSpeakerImage1;
        } catch (e) {
          throw 'Erro ao carregar imagem do tio: $e';
        }
      }

      // Carrega imagem da tia
      if (urlSpeakerImage2 != null && urlSpeakerImage2!.isNotEmpty) {
        try {
          originalSpeakerImage2 = await _speakerController.getSpeakerImage(
              speakerId: widget.editingSpeaker!.id, path: 'aunt.png');
          speakerImage2 = originalSpeakerImage2;
        } catch (e) {
          throw 'Erro ao carregar imagem da tia: $e';
        }
      }

      setState(() {
        _isLoadingSpeakerImage1 = false;
        _isLoadingSpeakerImage2 = false;
      });
    } else {
      // Palestrante individual
      setState(() {
        _isLoadingSpeakerImage1 = true;
      });

      if (urlSpeakerImage1 != null && urlSpeakerImage1!.isNotEmpty) {
        try {
          originalSpeakerImage1 = await _speakerController.getSpeakerImage(
              speakerId: widget.editingSpeaker!.id, path: 'speaker.png');
          speakerImage1 = originalSpeakerImage1;
        } catch (e) {
          throw 'Erro ao carregar imagem: $e';
        }
      }

      setState(() {
        _isLoadingSpeakerImage1 = false;
      });
    }
  }
}
