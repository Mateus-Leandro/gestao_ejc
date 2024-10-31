import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gestao_ejc/components/buttons/custom_cancel_button.dart';
import 'package:gestao_ejc/components/buttons/custom_confirmation_button.dart';
import 'package:gestao_ejc/components/buttons/custom_icon_button.dart';
import 'package:gestao_ejc/controllers/encounter_controller.dart';
import 'package:gestao_ejc/functions/function_date.dart';
import 'package:gestao_ejc/functions/function_int_to_roman.dart';
import 'package:gestao_ejc/functions/function_music_icon.dart';
import 'package:gestao_ejc/models/encounter_model.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:gestao_ejc/theme/app_theme.dart';

class EncounterInfoScreen extends StatefulWidget {
  final EncounterModel encounterModel;

  const EncounterInfoScreen({super.key, required this.encounterModel});

  @override
  State<EncounterInfoScreen> createState() => _EncounterInfoScreenState();
}

class _EncounterInfoScreenState extends State<EncounterInfoScreen> {
  @override
  void initState() {
    super.initState();
    encounterNameController.text =
        '${functionIntToRoman.convert(widget.encounterModel.sequential)} EJC Céu Azul';
    locationController.text = widget.encounterModel.location;
    musicThemeController.text = widget.encounterModel.themeSong;
    musicThemeLinkController.text = widget.encounterModel.themeSongLink;
    musicIcon = functionMusicIcon.getIcon(
        musicLink: widget.encounterModel.themeSongLink);
    selectedDates.add(DateTime.fromMillisecondsSinceEpoch(
        widget.encounterModel.initialDate.millisecondsSinceEpoch));
    selectedDates.add(DateTime.fromMillisecondsSinceEpoch(
        widget.encounterModel.finalDate.millisecondsSinceEpoch));
  }

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
  List<DateTime?> selectedDates = [];
  bool activeFields = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var musicIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: FlutterLogo(),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
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
                    CustomCancelButton(onPressed: () {
                      locationController.text = widget.encounterModel.location;
                      musicThemeLinkController.text =
                          widget.encounterModel.themeSongLink;
                      musicThemeController.text =
                          widget.encounterModel.themeSong;
                      _activeFields();
                    }),
                    const SizedBox(width: 20),
                    CustomConfirmationButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _saveEncounter();
                        }
                      },
                    )
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
                        labelStyle: TextStyle(fontSize: 20)),
                    controller: encounterNameController,
                    enabled: false,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Local',
                        labelStyle: TextStyle(fontSize: 20)),
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
                        labelStyle: TextStyle(fontSize: 20)),
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
                      suffixIcon: musicIcon,
                    ),
                    controller: musicThemeLinkController,
                    enabled: activeFields,
                    onChanged: (value) {
                      setState(() {
                        musicIcon = functionMusicIcon.getIcon(musicLink: value);
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
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _activeFields() {
    setState(() {
      activeFields = !activeFields;
    });
  }

  void _saveEncounter() {
    if (selectedDates.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Por favor, selecione as datas do encontro')),
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
    encounterController.saveEncounter(encounter: widget.encounterModel);
    _activeFields();
  }
}
