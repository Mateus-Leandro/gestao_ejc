import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gestao_ejc/components/SnackBars/custom_snack_bar.dart';
import 'package:gestao_ejc/components/buttons/custom_delete_button.dart';
import 'package:gestao_ejc/components/buttons/custom_edit_button.dart';
import 'package:gestao_ejc/components/forms/custom_lecture_form.dart';
import 'package:gestao_ejc/components/utils/custom_list_tile.dart';
import 'package:gestao_ejc/components/utils/custom_search_row.dart';
import 'package:gestao_ejc/controllers/lecture_controller.dart';
import 'package:gestao_ejc/functions/function_date.dart';
import 'package:gestao_ejc/models/encounter_model.dart';
import 'package:gestao_ejc/models/lecture_model.dart';
import 'package:gestao_ejc/models/speaker_couple_model.dart';
import 'package:gestao_ejc/models/speaker_model.dart';
import 'package:gestao_ejc/services/auth_service.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:intl/intl.dart';

class LectureScreen extends StatefulWidget {
  final EncounterModel encounter;
  const LectureScreen({Key? key, required this.encounter}) : super(key: key);

  @override
  State<LectureScreen> createState() => _LectureScreenState();
}

class _LectureScreenState extends State<LectureScreen> {
  final _searchCtrl = TextEditingController();
  final _lectureCtrl = getIt<LectureController>();
  final _auth = getIt<AuthService>();
  final _functionDate = getIt<FunctionDate>();

  Map<DocumentReference, AbstractSpeakerModel> _speakersMap = {};
  bool _loadingSpeakers = false;

  @override
  void initState() {
    super.initState();
    _lectureCtrl.init(sequentialEncounter: widget.encounter.sequential);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _lectureCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext ctx) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          CustomSearchRow(
            messageButton: 'Nova Palestra',
            functionButton: () => _showForm(null),
            showButton: true,
            inputType: TextInputType.text,
            controller: _searchCtrl,
            messageTextField: 'Pesquisar palestra',
            functionTextField: () => _lectureCtrl.getLectures(
                lectureName: _searchCtrl.text.trim().isEmpty
                    ? null
                    : _searchCtrl.text.trim()),
            iconButton: const Icon(Icons.add),
          ),
          Expanded(child: _buildList(ctx)),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext ctx) {
    return StreamBuilder<List<LectureModel>>(
      stream: _lectureCtrl.stream,
      builder: (ctx, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError) return Center(child: Text('Erro: ${snap.error}'));
        final lectures = snap.data ?? [];
        if (lectures.isEmpty) {
          return const Center(child: Text('Nenhuma palestra encontrada.'));
        }

        if (!_loadingSpeakers) {
          _loadingSpeakers = true;
          _lectureCtrl.getSpeakersForLectures(lectures).then((m) {
            _speakersMap = m;
            _loadingSpeakers = false;
            if (mounted) setState(() {});
          });
        }

        final byDay = <String, List<LectureModel>>{};
        for (var l in lectures) {
          final d = DateFormat('dd/MM/yyyy').format(l.startTime.toDate());
          byDay.putIfAbsent(d, () => []).add(l);
        }
        final days = byDay.keys.toList()..sort();

        return ListView.builder(
          itemCount: days.length,
          itemBuilder: (ctx, i) {
            final day = days[i];
            final dayList = byDay[day]!
              ..sort((a, b) => a.startTime.compareTo(b.startTime));
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(ctx).primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Text(day,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                ...dayList.map((lec) => _buildTile(ctx, lec)).toList(),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildTile(BuildContext ctx, LectureModel lecture) {
    // Obtém o tamanho da tela atual para decisões de responsividade
    final screenWidth = MediaQuery.of(ctx).size.width;
    final isSmallScreen = screenWidth < 600;

    var speakerName = 'Carregando...', speakerPhone = '';
    final ref = lecture.referenceSpeaker;
    if (_speakersMap.containsKey(ref)) {
      final sp = _speakersMap[ref]!;
      speakerName = sp.name;
      if (sp is SpeakerModel) {
        speakerPhone = sp.phone ?? '';
      } else if (sp is SpeakerCoupleModel) {
        final u = sp.uncle, a = sp.aunt;
        speakerPhone = [u?.phone, a?.phone].where((x) => x != null).join(' / ');
      }
    }

    final s = lecture.startTime.toDate(), e = lecture.endTime.toDate();
    final sStr =
        '${s.hour.toString().padLeft(2, '0')}:${s.minute.toString().padLeft(2, '0')}';
    final eStr =
        '${e.hour.toString().padLeft(2, '0')}:${e.minute.toString().padLeft(2, '0')}';
    final h = lecture.durationMinutes ~/ 60;
    final m = lecture.durationMinutes % 60;
    final dur = '${h > 0 ? '$h h ' : ''}${m > 0 || h == 0 ? '$m min' : ''}';

    // Versão responsiva para telas menores
    if (isSmallScreen) {
      return CustomListTile(
        listTile: ListTile(
          title: Text(
            lecture.name,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Palestrante: $speakerName',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              Text(
                'Horário: $sStr – $eStr ($dur)',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
          trailing: _auth.actualUserModel?.manipulateAdministrator == true
              ? _buildActionsMenu(ctx, lecture)
              : null,
          isThreeLine: false,
          onTap: () => _showLectureDetails(
              ctx, lecture, speakerName, speakerPhone, sStr, eStr, dur),
        ),
        defaultBackgroundColor: Colors.white,
      );
    }

    // Versão para telas maiores
    return CustomListTile(
      listTile: ListTile(
        title: Text(lecture.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Palestrante: $speakerName'),
            if (speakerPhone.isNotEmpty) Text('Contato: $speakerPhone'),
            Text('Horário: $sStr – $eStr'),
            Text('Duração: $dur'),
          ],
        ),
        trailing: _auth.actualUserModel?.manipulateAdministrator == true
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Tooltip(
                    message: 'Editar',
                    child: CustomEditButton(
                      form: CustomLectureForm(
                          encounter: widget.encounter, editingLecture: lecture),
                    ),
                  ),
                  Tooltip(
                    message: 'Excluir',
                    child: CustomDeleteButton(
                      alertMessage: 'Excluir palestra?',
                      deleteFunction: () => _delete(lecture),
                    ),
                  ),
                ],
              )
            : null,
        isThreeLine: true,
      ),
      defaultBackgroundColor: Colors.white,
    );
  }

  // Menu de ações para telas pequenas
  Widget _buildActionsMenu(BuildContext ctx, LectureModel lecture) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) {
        if (value == 'edit') {
          showDialog(
            barrierDismissible: false,
            context: ctx,
            builder: (_) => CustomLectureForm(
                encounter: widget.encounter, editingLecture: lecture),
          );
        } else if (value == 'delete') {
          _delete(lecture);
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem<String>(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit, color: Colors.orange),
              SizedBox(width: 8),
              Text('Editar'),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, color: Colors.red),
              SizedBox(width: 8),
              Text('Excluir'),
            ],
          ),
        ),
      ],
    );
  }

  // Diálogo de detalhes para telas pequenas
  void _showLectureDetails(
      BuildContext ctx,
      LectureModel lecture,
      String speakerName,
      String speakerPhone,
      String startTime,
      String endTime,
      String duration) {
    final screenWidth = MediaQuery.of(ctx).size.width;
    final screenHeight = MediaQuery.of(ctx).size.height;

    // Calcula o tamanho do diálogo baseado no tamanho da tela
    final dialogWidth = screenWidth * 0.9 < 400 ? screenWidth * 0.9 : 400.0;
    final dialogHeight = screenHeight * 0.6 < 500 ? screenHeight * 0.6 : 500.0;

    showDialog(
      context: ctx,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: dialogWidth,
            constraints: BoxConstraints(
              maxHeight: dialogHeight,
              minHeight: 200,
            ),
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    lecture.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 12),
                  _detailRow(Icons.person, 'Palestrante', speakerName),
                  if (speakerPhone.isNotEmpty)
                    _detailRow(Icons.phone, 'Contato', speakerPhone),
                  _detailRow(
                      Icons.access_time, 'Horário', '$startTime – $endTime'),
                  _detailRow(Icons.timelapse, 'Duração', duration),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Fechar'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Helper para criar linhas de detalhes
  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[700]),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showForm(LectureModel? l) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) =>
          CustomLectureForm(encounter: widget.encounter, editingLecture: l),
    );
  }

  Future<void> _delete(LectureModel lecture) async {
    try {
      await _lectureCtrl.deleteLecture(lecture: lecture);
      CustomSnackBar.show(
        context: context,
        message: 'Excluída com sucesso!',
        colorBar: Colors.green,
      );
    } catch (e) {
      CustomSnackBar.show(
        context: context,
        message: 'Erro ao excluir: $e',
        colorBar: Colors.red,
      );
    }
  }
}
