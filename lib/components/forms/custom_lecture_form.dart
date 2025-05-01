// lib/components/forms/custom_lecture_form.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gestao_ejc/components/SnackBars/custom_snack_bar.dart';
import 'package:gestao_ejc/components/buttons/custom_cancel_button.dart';
import 'package:gestao_ejc/components/buttons/custom_confirmation_button.dart';
import 'package:gestao_ejc/components/forms/custom_model_form.dart';
import 'package:gestao_ejc/components/pickers/custom_date_picker.dart';
import 'package:gestao_ejc/controllers/lecture_controller.dart';
import 'package:gestao_ejc/controllers/speaker_controller.dart';
import 'package:gestao_ejc/functions/function_date.dart';
import 'package:gestao_ejc/models/encounter_model.dart';
import 'package:gestao_ejc/models/lecture_model.dart';
import 'package:gestao_ejc/models/speaker_model.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:uuid/uuid.dart';

class CustomLectureForm extends StatefulWidget {
  final EncounterModel encounter;
  final LectureModel? editingLecture;

  const CustomLectureForm({
    Key? key,
    required this.encounter,
    this.editingLecture,
  }) : super(key: key);

  @override
  State<CustomLectureForm> createState() => _CustomLectureFormState();
}

class _CustomLectureFormState extends State<CustomLectureForm> {
  final _formKey = GlobalKey<FormState>();
  final _lectureNameController = TextEditingController();
  final _lectureDateController = TextEditingController();
  final _lectureStartTimeController = TextEditingController();
  final _lectureDurationHoursController = TextEditingController(text: '0');
  final _lectureDurationMinutesController = TextEditingController(text: '0');
  final _lectureEndTimeController = TextEditingController();

  final _lectureController = getIt<LectureController>();
  final _speakerController = getIt<SpeakerController>();
  final _functionDate = getIt<FunctionDate>();

  String? _selectedSpeakerId;
  List<AbstractSpeakerModel> _speakers = [];
  bool _isLoading = false;
  TimeOfDay? _startTime;
  late DateTime _encounterStartDate, _encounterEndDate;

  @override
  void initState() {
    super.initState();
    _encounterStartDate = widget.encounter.initialDate.toDate();
    _encounterEndDate = widget.encounter.finalDate.toDate();
    _loadSpeakers();

    if (widget.editingLecture != null) {
      final lec = widget.editingLecture!;
      _lectureNameController.text = lec.name;
      _lectureDateController.text =
          _functionDate.getStringFromTimestamp(lec.startTime);
      final start = lec.startTime.toDate();
      _startTime = TimeOfDay(hour: start.hour, minute: start.minute);
      _lectureStartTimeController.text = _formatTimeOfDay(_startTime!);
      final hours = lec.durationMinutes ~/ 60;
      final mins = lec.durationMinutes % 60;
      _lectureDurationHoursController.text = hours.toString();
      _lectureDurationMinutesController.text = mins.toString();
      final end = lec.endTime.toDate();
      _lectureEndTimeController.text =
          _formatTimeOfDay(TimeOfDay(hour: end.hour, minute: end.minute));
      _selectedSpeakerId = lec.referenceSpeaker.id;
    }
  }

  Future<void> _loadSpeakers() async {
    setState(() => _isLoading = true);
    _speakerController.init();
    final list = await _speakerController.stream!.first;
    setState(() {
      _speakers = list;
      _isLoading = false;
    });
  }

  String _formatTimeOfDay(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return CustomModelForm(
      title:
          widget.editingLecture != null ? 'Editar Palestra' : 'Nova Palestra',
      formKey: _formKey,
      formBody: _buildFormBody(),
      actions: [
        CustomCancelButton(onPressed: () => Navigator.of(context).pop()),
        CustomConfirmationButton(onPressed: _saveLecture),
      ],
    );
  }

  List<Widget> _buildFormBody() {
    return [
      if (_isLoading)
        const Center(child: CircularProgressIndicator())
      else
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Palestrante',
                border: OutlineInputBorder(),
              ),
              value: _selectedSpeakerId,
              items: _speakers
                  .map(
                      (s) => DropdownMenuItem(value: s.id, child: Text(s.name)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedSpeakerId = v),
              validator: (v) =>
                  v == null ? 'Por favor, selecione um palestrante' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Nome da Palestra',
                border: OutlineInputBorder(),
              ),
              controller: _lectureNameController,
              validator: (v) =>
                  (v == null || v.isEmpty) ? 'Por favor, insira o nome' : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomDatePicker(
                    controller: _lectureDateController,
                    labelText: 'Data',
                    lowestDate: _encounterStartDate,
                    higherDate: _encounterEndDate,
                    active: true,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _lectureStartTimeController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Horário de Início',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.access_time),
                        onPressed: () => _selectTime(context),
                      ),
                    ),
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Selecione o horário' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Duração',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _lectureDurationHoursController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Horas',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => _calculateEndTime(),
                    validator: (v) {
                      final n = int.tryParse(v ?? '') ?? -1;
                      return n < 0 ? 'Valor inválido' : null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _lectureDurationMinutesController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Minutos',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => _calculateEndTime(),
                    validator: (v) {
                      final n = int.tryParse(v ?? '') ?? -1;
                      return (n < 0 || n > 59) ? 'Valor inválido (0–59)' : null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _lectureEndTimeController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Horário de Término (calculado automaticamente)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'A palestra deve acontecer durante o encontro '
              '(${_functionDate.getStringFromTimestamp(widget.encounter.initialDate)} a '
              '${_functionDate.getStringFromTimestamp(widget.encounter.finalDate)}).',
              style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[600]),
            ),
          ],
        ),
    ];
  }

  Future<void> _selectTime(BuildContext ctx) async {
    final pick = await showTimePicker(
      context: ctx,
      initialTime: _startTime ?? TimeOfDay.now(),
    );
    if (pick != null) {
      setState(() {
        _startTime = pick;
        _lectureStartTimeController.text = _formatTimeOfDay(pick);
        _calculateEndTime();
      });
    }
  }

  void _calculateEndTime() {
    if (_startTime == null) return;
    final h = int.tryParse(_lectureDurationHoursController.text) ?? 0;
    final m = int.tryParse(_lectureDurationMinutesController.text) ?? 0;
    final startMin = _startTime!.hour * 60 + _startTime!.minute;
    final totalMin = h * 60 + m;
    final end = startMin + totalMin;
    final eh = (end ~/ 60) % 24;
    final em = end % 60;
    _lectureEndTimeController.text = '${eh.toString().padLeft(2, '0')}:'
        '${em.toString().padLeft(2, '0')}';
  }

  int _totalMinutes() {
    final h = int.tryParse(_lectureDurationHoursController.text) ?? 0;
    final m = int.tryParse(_lectureDurationMinutesController.text) ?? 0;
    return h * 60 + m;
  }

  void _saveLecture() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedSpeakerId == null ||
        _lectureDateController.text.isEmpty ||
        _lectureStartTimeController.text.isEmpty) {
      CustomSnackBar.show(
        context: context,
        message: 'Preencha todos os campos obrigatórios',
        colorBar: Colors.red,
      );
      return;
    }
    final total = _totalMinutes();
    if (total <= 0) {
      CustomSnackBar.show(
        context: context,
        message: 'Duração deve ser maior que zero',
        colorBar: Colors.red,
      );
      return;
    }
    try {
      final date =
          _functionDate.getDateFromStringFormatted(_lectureDateController.text);
      final parts = _lectureStartTimeController.text.split(':');
      final start = DateTime(
        date.year,
        date.month,
        date.day,
        int.parse(parts[0]),
        int.parse(parts[1]),
      );
      final end = start.add(Duration(minutes: total));
      if (start.isBefore(_encounterStartDate) ||
          end.isAfter(_encounterEndDate.add(const Duration(days: 1)))) {
        CustomSnackBar.show(
          context: context,
          message: 'Fora do período do encontro',
          colorBar: Colors.red,
        );
        return;
      }

      final speakerRef = FirebaseFirestore.instance
          .collection('speakers')
          .doc(_selectedSpeakerId);

      final lecture = LectureModel(
        id: widget.editingLecture?.id ?? const Uuid().v4(),
        referenceSpeaker: speakerRef,
        name: _lectureNameController.text.trim(),
        startTime: Timestamp.fromDate(start),
        durationMinutes: total,
        endTime: Timestamp.fromDate(end),
        sequentialEncounter: widget.encounter.sequential,
      );

      await _lectureController.saveLecture(lecture: lecture);
      CustomSnackBar.show(
        context: context,
        message: 'Palestra salva com sucesso!',
        colorBar: Colors.green,
      );
      Navigator.of(context).pop();
    } catch (e) {
      CustomSnackBar.show(
        context: context,
        message: 'Erro ao salvar: $e',
        colorBar: Colors.red,
      );
    }
  }
}
