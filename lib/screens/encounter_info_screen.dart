import 'dart:typed_data';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gestao_ejc/components/buttons/custom_cancel_button.dart';
import 'package:gestao_ejc/components/buttons/custom_confirmation_button.dart';
import 'package:gestao_ejc/components/buttons/custom_icon_button.dart';
import 'package:gestao_ejc/components/buttons/custom_pick_file_button.dart';
import 'package:gestao_ejc/controllers/encounter_controller.dart';
import 'package:gestao_ejc/functions/function_call_url.dart';
import 'package:gestao_ejc/functions/function_date.dart';
import 'package:gestao_ejc/functions/function_int_to_roman.dart';
import 'package:gestao_ejc/functions/function_music_icon.dart';
import 'package:gestao_ejc/functions/function_pick_image.dart';
import 'package:gestao_ejc/models/encounter_model.dart';
import 'package:gestao_ejc/services/firebase_storage_service.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:gestao_ejc/theme/app_theme.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';

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

  List<DateTime?> selectedDates = [];
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
    selectedDates.add(DateTime.fromMillisecondsSinceEpoch(
        widget.encounterModel.initialDate.millisecondsSinceEpoch));
    selectedDates.add(DateTime.fromMillisecondsSinceEpoch(
        widget.encounterModel.finalDate.millisecondsSinceEpoch));

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
                  const Center(child: CircularProgressIndicator())
                else
                  CustomPickFileButton(
                    onPressed: () {
                      if (activeFields) {
                        _pickImage();
                      }
                    },
                    icon: Tooltip(
                      message: activeFields ? 'Selecionar Imagem Tema' : '',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Opacity(
                          opacity: !activeFields ? 0.5 : 1.0,
                          child: themeImage != null
                              ? Image.memory(
                                  themeImage!,
                                  height: 250,
                                  width: 250,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(Icons.photo),
                        ),
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
                  ] else ...[
                    if (!_isLoading) ...[
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
                    ]
                  ],
                ],
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Encontro',
                      labelStyle: TextStyle(fontSize: 20),
                    ),
                    controller: encounterNameController,
                    enabled: false,
                  ),
                  TextFormField(
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
                  Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 15),
                    child: Text(
                      'Dias do encontro',
                      style: TextStyle(
                        fontSize: 18,
                        color: activeFields ? Colors.black : Colors.grey[300],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 350,
                    height: 320,
                    child: Container(
                      decoration: BoxDecoration(
                        color: activeFields
                            ? Colors.transparent
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: AbsorbPointer(
                        absorbing: !activeFields,
                        child: CalendarDatePicker2(
                          config: CalendarDatePicker2Config(
                            disableModePicker: true,
                            calendarType: CalendarDatePicker2Type.range,
                          ),
                          value: selectedDates,
                          onValueChanged: (dates) {
                            setState(() {
                              selectedDates = dates;
                            });
                          },
                        ),
                      ),
                    ),
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
    if (selectedDates.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecione as datas do encontro'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    widget.encounterModel.initialDate =
        functionDate.getTimestampFromDateTime(selectedDates[0]!);
    widget.encounterModel.finalDate =
        functionDate.getTimestampFromDateTime(selectedDates[1]!);
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

    await encounterController.saveEncounter(
        encounter: widget.encounterModel, newEncounter: widget.newEncounter);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Encontro salvo com sucesso.'),
        backgroundColor: Colors.green,
      ),
    );
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
}
