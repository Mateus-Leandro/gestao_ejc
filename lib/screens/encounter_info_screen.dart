import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:gestao_ejc/components/SnackBars/custom_snack_bar.dart';
import 'package:gestao_ejc/components/buttons/custom_cancel_button.dart';
import 'package:gestao_ejc/components/buttons/custom_confirmation_button.dart';
import 'package:gestao_ejc/components/buttons/custom_icon_button.dart';
import 'package:gestao_ejc/components/buttons/custom_pick_file_button.dart';
import 'package:gestao_ejc/components/forms/custom_export_quadrant_form.dart';
import 'package:gestao_ejc/components/pickers/custom_date_picker.dart';
import 'package:gestao_ejc/controllers/encounter_controller.dart';
import 'package:gestao_ejc/functions/function_call_url.dart';
import 'package:gestao_ejc/functions/function_date.dart';
import 'package:gestao_ejc/functions/function_int_to_roman.dart';
import 'package:gestao_ejc/functions/function_music_icon.dart';
import 'package:gestao_ejc/functions/function_pick_image.dart';
import 'package:gestao_ejc/models/encounter_model.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:gestao_ejc/theme/app_theme.dart';

class EncounterInfoScreen extends StatefulWidget {
  final EncounterModel encounterModel;
  final bool newEncounter;

  const EncounterInfoScreen({
    super.key,
    required this.encounterModel,
    required this.newEncounter,
  });

  @override
  State<EncounterInfoScreen> createState() => _EncounterInfoScreenState();
}

class _EncounterInfoScreenState extends State<EncounterInfoScreen> {
  bool _isLoading = false;

  final AppTheme appTheme = getIt<AppTheme>();
  final TextEditingController encounterNameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController musicThemeController = TextEditingController();
  final TextEditingController musicThemeLinkController =
      TextEditingController();

  final FunctionIntToRoman functionIntToRoman = getIt<FunctionIntToRoman>();
  final FunctionDate functionDate = getIt<FunctionDate>();
  final FunctionMusicIcon functionMusicIcon = getIt<FunctionMusicIcon>();
  final EncounterController encounterController = getIt<EncounterController>();
  final FunctionCallUrl functionCallUrl = getIt<FunctionCallUrl>();
  final FunctionPickImage functionPickImage = getIt<FunctionPickImage>();
  final TextEditingController _initialEncounterDateController =
      TextEditingController();
  final TextEditingController _finalEncounterDateController =
      TextEditingController();

  late bool activeFields;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var musicIcon;
  Uint8List? themeImage;
  Uint8List? originalThemeImage;

  @override
  void initState() {
    super.initState();
    encounterNameController.text =
        '${functionIntToRoman.convert(widget.encounterModel.sequential)} EJC Céu Azul';
    locationController.text = widget.encounterModel.location;
    musicThemeController.text = widget.encounterModel.themeSong;
    musicThemeLinkController.text = widget.encounterModel.themeSongLink;
    activeFields = widget.newEncounter;
    musicIcon = functionMusicIcon.getIcon(
      musicLink: widget.encounterModel.themeSongLink,
      activeFields: activeFields,
    );
    _initialEncounterDateController.text =
        functionDate.getStringFromTimestamp(widget.encounterModel.initialDate);
    _finalEncounterDateController.text =
        functionDate.getStringFromTimestamp(widget.encounterModel.finalDate);

    if (widget.encounterModel.urlImageTheme.isNotEmpty) {
      _getImageTheme();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (_isLoading)
                  const SizedBox(
                    height: 250,
                    width: 250,
                    child: Center(child: CircularProgressIndicator()),
                  )
                else
                  CustomPickFileButton(
                    onPressed: () {
                      if (activeFields) {
                        _pickImage();
                      }
                    },
                    icon: Tooltip(
                      message: activeFields ? 'Selecionar Imagem Tema' : '',
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: themeImage != null
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
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.image,
                                                size: 50, color: Colors.grey),
                                            SizedBox(height: 8),
                                            Text(
                                              'Selecionar Imagem Tema',
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),
                          if (themeImage != null && activeFields) ...[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: IconButton(
                                iconSize: 30,
                                icon:
                                    const Icon(Icons.close, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    themeImage = null;
                                  });
                                },
                                tooltip: 'Remover Imagem',
                              ),
                            ),
                          ]
                        ],
                      ),
                    ),
                  )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (!activeFields) ...[
                    CustomIconButton(
                      message: 'Editar Encontro',
                      function: () {
                        _activeFields();
                      },
                      icon: const Icon(Icons.edit),
                    ),
                    CustomIconButton(
                      message: 'Exportar Quadrante',
                      function: () {
                        _showExportQuadrantForm();
                      },
                      icon: const Icon(Icons.picture_as_pdf_outlined),
                    ),
                  ] else ...[
                    CustomCancelButton(
                      onPressed: () {
                        widget.newEncounter
                            ? Navigator.of(context).pop()
                            : locationController.text =
                                widget.encounterModel.location;
                        musicThemeLinkController.text =
                            widget.encounterModel.themeSongLink;
                        musicThemeController.text =
                            widget.encounterModel.themeSong;
                        themeImage = originalThemeImage;
                        _initialEncounterDateController.text =
                            functionDate.getStringFromTimestamp(
                                widget.encounterModel.initialDate);
                        _finalEncounterDateController.text =
                            functionDate.getStringFromTimestamp(
                                widget.encounterModel.finalDate);
                        _activeFields();
                      },
                    ),
                    const SizedBox(width: 20),
                    CustomConfirmationButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _saveEncounter();
                        }
                      },
                    ),
                  ],
                ],
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        flex: 5,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Encontro',
                            labelStyle: TextStyle(fontSize: 20),
                          ),
                          controller: encounterNameController,
                          enabled: false,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        flex: 6,
                        fit: FlexFit.loose,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Local',
                            labelStyle: TextStyle(fontSize: 20),
                          ),
                          controller: locationController,
                          enabled: activeFields,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Local não pode ser vazio';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Música Tema',
                      labelStyle: TextStyle(fontSize: 20),
                    ),
                    controller: musicThemeController,
                    enabled: activeFields,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Música Tema não pode ser vazio';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Link música',
                      labelStyle: TextStyle(fontSize: 20),
                      suffixIcon: IconButton(
                        onPressed: () => musicThemeLinkController
                                .text.isNotEmpty
                            ? functionCallUrl
                                .callUrl(musicThemeLinkController.text.trim())
                            : null,
                        icon: musicIcon,
                      ),
                    ),
                    controller: musicThemeLinkController,
                    enabled: activeFields,
                    onChanged: (value) {
                      setState(() {
                        musicIcon = functionMusicIcon.getIcon(
                            musicLink: value, activeFields: activeFields);
                      });
                    },
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Dias do encontro',
                    style: TextStyle(
                      fontSize: 18,
                      color: activeFields ? Colors.black : Colors.grey[300],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        flex: 5,
                        child: CustomDatePicker(
                          controller: _initialEncounterDateController,
                          labelText: 'Data Inicial',
                          active: activeFields,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 5,
                        child: CustomDatePicker(
                          controller: _finalEncounterDateController,
                          labelText: 'Data Final',
                          active: activeFields,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getImageTheme() async {
    setState(() {
      _isLoading = true;
    });

    themeImage = await encounterController.getImageTheme(
        sequential: widget.encounterModel.sequential);

    originalThemeImage = themeImage;
    setState(() {
      _isLoading = false;
    });
  }

  void _activeFields() {
    setState(() {
      activeFields = !activeFields;
      musicIcon = functionMusicIcon.getIcon(
          musicLink: musicThemeLinkController.text.trim(),
          activeFields: activeFields);
    });
  }

  void _saveEncounter() async {
    DateTime initialDate = functionDate.getDateFromStringFormatted(
        _initialEncounterDateController.text.trim());
    DateTime finalDate = functionDate
        .getDateFromStringFormatted(_finalEncounterDateController.text.trim());

    if (functionDate
        .getDaysBetweenDates(initialDate: initialDate, finalDate: finalDate)
        .isNegative) {
      CustomSnackBar.show(
        context: context,
        message:
            'Data inicial do encontro não pode ser posterior a data final!',
        colorBar: Colors.red,
      );
      return;
    }
    widget.encounterModel.initialDate = functionDate
        .getTimestampFromString(_initialEncounterDateController.text.trim());
    widget.encounterModel.finalDate = functionDate
        .getTimestampFromString(_finalEncounterDateController.text.trim());
    widget.encounterModel.location = locationController.text.trim();
    widget.encounterModel.themeSong = musicThemeController.text.trim();
    widget.encounterModel.themeSongLink = musicThemeLinkController.text.trim();

    if (themeImage != null) {
      widget.encounterModel.urlImageTheme =
          await encounterController.saveImageTheme(
              imageTheme: themeImage!,
              sequential: widget.encounterModel.sequential);
    } else {
      widget.encounterModel.urlImageTheme = '';
      await encounterController.removeImageTheme(
          sequential: widget.encounterModel.sequential);
    }
    try {
      await encounterController.saveEncounter(
          encounter: widget.encounterModel, newEncounter: widget.newEncounter);
    } catch (e) {
      CustomSnackBar.show(
        context: context,
        message: 'Erro ao salvar encontro: $e',
        colorBar: Colors.red,
      );
    }
    _activeFields();
  }

  Future<void> _pickImage() async {
    setState(() {
      _isLoading = true;
    });
    themeImage = await functionPickImage.getSingleImage();
    themeImage ??= originalThemeImage;
    setState(() {
      _isLoading = false;
    });
  }

  void _showExportQuadrantForm() async {
    await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return CustomExportQuadrantForm(
          encounter: widget.encounterModel,
        );
      },
    );
  }
}
