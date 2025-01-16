import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gestao_ejc/components/SnackBars/custom_snack_bar.dart';
import 'package:gestao_ejc/components/buttons/custom_cancel_button.dart';
import 'package:gestao_ejc/components/buttons/custom_confirmation_button.dart';
import 'package:gestao_ejc/components/buttons/custom_pick_file_button.dart';
import 'package:gestao_ejc/components/drawers/custom_color_drawer.dart';
import 'package:gestao_ejc/components/forms/custom_model_form.dart';
import 'package:gestao_ejc/controllers/circle_controller.dart';
import 'package:gestao_ejc/functions/function_color.dart';
import 'package:gestao_ejc/functions/function_pick_image.dart';
import 'package:gestao_ejc/models/circle_model.dart';
import 'package:gestao_ejc/models/encounter_model.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:uuid/uuid.dart';

class CustomCircleForm extends StatefulWidget {
  final CircleModel? editingCircle;
  final EncounterModel encounter;
  final List<CircleModel>? circles;

  const CustomCircleForm(
      {super.key, this.editingCircle, required this.encounter, this.circles});

  @override
  State<CustomCircleForm> createState() => _CustomCircleFormState();
}

class _CustomCircleFormState extends State<CustomCircleForm> {
  String? selectedColorHex;
  final formKey = GlobalKey<FormState>();
  final CircleController _circleController = getIt<CircleController>();
  final FunctionPickImage functionPickImage = getIt<FunctionPickImage>();
  final TextEditingController _circleNameController = TextEditingController();
  final FunctionColor _functionColor = getIt<FunctionColor>();
  bool _colorSelectionError = false;
  bool _isLoadingThemeImage = false;
  bool _isLoadingCircleImage = false;
  bool _isLoadingSaveCircle = false;
  Color? initialColor;
  Uint8List? themeImage;
  Uint8List? originalThemeImage;
  Uint8List? circleImage;
  Uint8List? originalCircleImage;
  String? urlThemeImage = '';
  String? urlCircleImage = '';

  @override
  void initState() {
    super.initState();
    if (widget.editingCircle != null) {
      _circleNameController.text = widget.editingCircle?.name ?? '';
      selectedColorHex = widget.editingCircle!.colorHex;
      initialColor = _functionColor.getFromHexadecimal(selectedColorHex!);
      urlThemeImage = widget.editingCircle!.urlThemeImage;
      urlCircleImage = widget.editingCircle!.urlCircleImage;
      _loadImages();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomModelForm(
      title: widget.editingCircle != null ? 'Editar Círculo' : 'Criar Círculo',
      formKey: formKey,
      formBody: _buildFormBody(),
      actions: [
        if (_isLoadingSaveCircle) ...[
          const Text('Salvando círculo, aguarde...'),
          const CircularProgressIndicator()
        ] else ...[
          CustomCancelButton(
            onPressed: () => Navigator.of(context).pop(),
          ),
          CustomConfirmationButton(
            onPressed: () {
              setState(() {
                _colorSelectionError = selectedColorHex == null;
              });

              if (formKey.currentState!.validate() && !_colorSelectionError) {
                setState(() {
                  _isLoadingSaveCircle = true;
                });
                _saveCircle();
              }
            },
          ),
        ]
      ],
    );
  }

  void _saveCircle() async {
    try {
      final String circleId = widget.editingCircle?.id ?? const Uuid().v4();
      if (themeImage != originalThemeImage) {
        if (themeImage != null) {
          urlThemeImage = await _circleController.saveCircleImage(
            image: themeImage!,
            sequentialEncounter: widget.encounter.sequential,
            circleId: circleId,
            fileName: 'themeImage',
          );
        } else {
          await _circleController.removeCircleImage(
            sequentialEncounter: widget.encounter.sequential,
            circleId: circleId,
            fileName: 'themeImage',
          );
        }
      }

      if (circleImage != originalCircleImage) {
        if (circleImage != null) {
          urlCircleImage = await _circleController.saveCircleImage(
            image: circleImage!,
            sequentialEncounter: widget.encounter.sequential,
            circleId: circleId,
            fileName: 'circleImage',
          );
        } else {
          await _circleController.removeCircleImage(
            sequentialEncounter: widget.encounter.sequential,
            circleId: circleId,
            fileName: 'circleImage',
          );
        }
      }

      CircleModel circle = CircleModel(
        id: circleId,
        sequentialEncounter: widget.encounter.sequential,
        name: _circleNameController.text.trim(),
        colorHex: selectedColorHex!,
        urlThemeImage: urlThemeImage,
        urlCircleImage: urlCircleImage,
      );

      await _circleController.saveCircle(circle: circle);
      CustomSnackBar.show(
        context: context,
        message: 'Círculo salvo com sucesso!',
        colorBar: Colors.green,
      );
    } catch (e) {
      CustomSnackBar.show(
        context: context,
        message: 'Erro ao salvar círculo: $e',
        colorBar: Colors.red,
      );
    } finally {
      Navigator.of(context).pop();
    }
  }

  _buildFormBody() {
    return [
      const Text('Cor do círculo'),
      CustomColorDrawer(
        initialColor: initialColor,
        colorSelected: (newColor) {
          setState(() {
            selectedColorHex = newColor[2];
            _colorSelectionError = false;
          });
        },
        tooltipMessage:
            widget.editingCircle == null ? 'Selecione a cor do círculo' : '',
        allowSelection: widget.editingCircle == null,
      ),
      if (_colorSelectionError)
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 3),
          child: Text(
            'Por favor, selecione uma cor para o círculo!',
            style: TextStyle(color: Colors.red, fontSize: 13),
          ),
        ),
      TextFormField(
        controller: _circleNameController,
        decoration: const InputDecoration(
          labelText: 'Nome do círculo',
        ),
        validator: (circleName) {
          if (circleName == null || circleName.isEmpty) {
            return 'Informe o nome do círculo';
          }
          return null;
        },
      ),
      Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    flex: 5,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Imagem tema',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        CustomPickFileButton(
                          onPressed: () {
                            _pickThemeImage();
                          },
                          icon: Tooltip(
                            message: 'Selecionar Imagem Tema',
                            child: Opacity(
                              opacity: 1.0,
                              child: Stack(
                                alignment: Alignment.topRight,
                                fit: StackFit.loose,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: _isLoadingThemeImage
                                        ? const CircularProgressIndicator()
                                        : themeImage != null
                                            ? Image.memory(
                                                themeImage!,
                                                height: 250,
                                                width: 250,
                                                fit: BoxFit.cover,
                                              )
                                            : const Card(
                                                elevation: 5,
                                                child: Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text(
                                                      'Selecionar imagem tema'),
                                                ),
                                              ),
                                  ),
                                  if (themeImage != null) ...[
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: IconButton(
                                        iconSize: 35,
                                        icon: const Icon(Icons.close,
                                            color: Colors.red, size: 30),
                                        onPressed: () {
                                          setState(() {
                                            themeImage = null;
                                          });
                                        },
                                        tooltip: 'Remover Imagem tema',
                                      ),
                                    ),
                                  ]
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 5,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Imagem do círculo',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        CustomPickFileButton(
                          onPressed: () {
                            _pickCircleImage();
                          },
                          icon: Tooltip(
                            message: 'Selecionar imagem criada pelo círculo',
                            child: Opacity(
                              opacity: 1.0,
                              child: Stack(
                                alignment: Alignment.topRight,
                                fit: StackFit.loose,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: _isLoadingCircleImage
                                        ? const CircularProgressIndicator()
                                        : circleImage != null
                                            ? Image.memory(
                                                circleImage!,
                                                height: 250,
                                                width: 250,
                                                fit: BoxFit.cover,
                                              )
                                            : const Card(
                                                elevation: 5,
                                                child: Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text(
                                                      'Selecionar imagem do círculo'),
                                                ),
                                              ),
                                  ),
                                  if (circleImage != null) ...[
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: IconButton(
                                        iconSize: 35,
                                        icon: const Icon(Icons.close,
                                            color: Colors.red, size: 30),
                                        onPressed: () {
                                          setState(() {
                                            circleImage = null;
                                          });
                                        },
                                        tooltip: 'Remover imagem do círculo',
                                      ),
                                    ),
                                  ]
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ];
  }

  Future<void> _pickThemeImage() async {
    setState(() {
      _isLoadingThemeImage = true;
    });
    themeImage = await functionPickImage.getSingleImage();
    themeImage ??= originalThemeImage;
    setState(() {
      _isLoadingThemeImage = false;
    });
  }

  Future<void> _pickCircleImage() async {
    setState(() {
      _isLoadingCircleImage = true;
    });
    circleImage = await functionPickImage.getSingleImage();
    circleImage ??= originalCircleImage;
    setState(() {
      _isLoadingCircleImage = false;
    });
  }

  Future<void> _loadImages() async {
    setState(() {
      _isLoadingThemeImage = true;
      _isLoadingCircleImage = true;
    });

    originalThemeImage = null;
    if (widget.editingCircle!.urlThemeImage!.isNotEmpty) {
      originalThemeImage = await _circleController.getCircleImage(
        circleId: widget.editingCircle!.id,
        fileName: 'themeImage',
        sequentialEncounter: widget.encounter.sequential,
      );
    }

    originalCircleImage = null;
    if (widget.editingCircle!.urlCircleImage!.isNotEmpty) {
      originalCircleImage = await _circleController.getCircleImage(
        circleId: widget.editingCircle!.id,
        fileName: 'circleImage',
        sequentialEncounter: widget.encounter.sequential,
      );
    }

    themeImage = originalThemeImage;
    circleImage = originalCircleImage;

    setState(() {
      _isLoadingThemeImage = false;
      _isLoadingCircleImage = false;
    });
  }
}
