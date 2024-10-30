import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:gestao_ejc/components/buttons/custom_cancel_button.dart';
import 'package:gestao_ejc/components/buttons/custom_confirmation_button.dart';
import 'package:gestao_ejc/components/buttons/custom_icon_button.dart';
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
    localController.text = widget.encounterModel.location;
    musicThemeController.text = widget.encounterModel.themeSong;
    musicThemeLinkController.text = widget.encounterModel.themeSongLink;
    musicIcon = functionMusicIcon.getIcon(
        musicLink: widget.encounterModel.themeSongLink);
  }

  final AppTheme appTheme = getIt<AppTheme>();
  final TextEditingController encounterNameController = TextEditingController();
  final TextEditingController localController = TextEditingController();
  final TextEditingController musicThemeController = TextEditingController();
  final TextEditingController musicThemeLinkController =
      TextEditingController();
  final FunctionIntToRoman functionIntToRoman = getIt<FunctionIntToRoman>();
  final FunctionDate functionDate = getIt<FunctionDate>();
  final FunctionMusicIcon functionMusicIcon = getIt<FunctionMusicIcon>();
  final GlobalKey _formKey = GlobalKey();
  bool activeFields = false;
  var musicIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
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
                    CustomCancelButton(onPressed: () => _activeFields()),
                    SizedBox(width: 20),
                    CustomConfirmationButton(onPressed: () => _activeFields())
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
                    controller: localController,
                    enabled: activeFields,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Música Tema',
                        labelStyle: TextStyle(fontSize: 20)),
                    controller: musicThemeController,
                    enabled: activeFields,
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
                          musicIcon =
                              functionMusicIcon.getIcon(musicLink: value);
                        });
                      }),
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
                            value: [
                              DateTime.fromMillisecondsSinceEpoch(widget
                                  .encounterModel
                                  .initialDate
                                  .millisecondsSinceEpoch),
                              DateTime.fromMillisecondsSinceEpoch(widget
                                  .encounterModel
                                  .finalDate
                                  .millisecondsSinceEpoch)
                            ]),
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
}
