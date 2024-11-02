import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gestao_ejc/components/utils/custom_list_tile.dart';
import 'package:gestao_ejc/components/utils/custom_search_row.dart';
import 'package:gestao_ejc/controllers/encounter_controller.dart';
import 'package:gestao_ejc/functions/function_call_url.dart';
import 'package:gestao_ejc/functions/function_date.dart';
import 'package:gestao_ejc/functions/function_int_to_roman.dart';
import 'package:gestao_ejc/functions/function_music_icon.dart';
import 'package:gestao_ejc/models/encounter_model.dart';
import 'package:gestao_ejc/screens/encounter_info_screen.dart';
import 'package:gestao_ejc/screens/encounter_tabs_screen.dart';
import 'package:gestao_ejc/screens/model_screen.dart';
import 'package:gestao_ejc/theme/app_theme.dart';

import '../services/locator/service_locator.dart';

class EncounterScreen extends StatefulWidget {
  const EncounterScreen({super.key});

  @override
  State<EncounterScreen> createState() => _EncounterScreenState();
}

class _EncounterScreenState extends State<EncounterScreen> {
  final EncounterController encounterController = getIt<EncounterController>();
  final TextEditingController _encounterNameController =
      TextEditingController();
  final FunctionDate functionDate = getIt<FunctionDate>();
  final FunctionCallUrl functionCallUrl = getIt<FunctionCallUrl>();
  final AppTheme appTheme = getIt<AppTheme>();
  final FunctionIntToRoman functionIntToRoman = getIt<FunctionIntToRoman>();
  final FunctionMusicIcon functionMusicIcon = getIt<FunctionMusicIcon>();

  @override
  void initState() {
    encounterController.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModelScreen(
        title: 'Encontros',
        body: Column(
          children: [
            CustomSearchRow(
                messageButton: 'Criar Encontro',
                functionButton: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        title: const Text('Novo Encontro'),
                        content: SingleChildScrollView(
                          child: EncounterInfoScreen(
                            encounterModel: EncounterModel(
                                sequential: 0,
                                initialDate: Timestamp.now(),
                                finalDate: Timestamp.now(),
                                location: '',
                                themeSong: '',
                                themeSongLink: ''),
                            newEncounter: true,
                          ),
                        ),
                      );
                    },
                  );
                },
                showButton: true,
                inputType: TextInputType.text,
                controller: _encounterNameController,
                messageTextField: 'Pesquisar encontro',
                functionTextField: () {},
                iconButton: const Icon(Icons.add)),
            Expanded(child: _buildEncounterList(context))
          ],
        ),
        indexMenuSelected: 0,
        showMenuDrawer: true);
  }

  _buildEncounterList(BuildContext context) {
    return StreamBuilder(
      stream: encounterController.stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
              child: Text('Erro ao carregar encontros: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Nenhum encontro encontrado.'));
        }

        var encounters = snapshot.data!;
        return ListView.builder(
          itemCount: encounters.length,
          itemBuilder: (context, index) {
            var encounter = encounters[index];
            return _buildEncounterTile(context, encounter);
          },
        );
      },
    );
  }

  _buildEncounterTile(BuildContext context, EncounterModel encounter) {
    Widget musicIcon = functionMusicIcon.getIcon(
        musicLink: encounter.themeSongLink, activeFields: true);
    return CustomListTile(
        listTile: ListTile(
          title: Text(
              '${functionIntToRoman.convert(encounter.sequential)} - EJC Céu Azul'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${functionDate.getStringFromTimestamp(
                encounter.initialDate,
              )} - ${functionDate.getStringFromTimestamp(
                encounter.finalDate,
              )}'),
              Text('Local: ${encounter.location}'),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      'Música: ${encounter.themeSong}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    onPressed: () =>
                        functionCallUrl.callUrl(encounter.themeSongLink),
                    icon: Tooltip(
                      message: 'Música Tema',
                      child: musicIcon,
                    ),
                  ),
                ],
              )
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EncounterTabsScreen(encounterModel: encounter),
                        ),
                      ),
                  icon: const Icon(Icons.arrow_forward))
            ],
          ),
        ),
        defaultBackgroundColor: Colors.white);
  }
}
