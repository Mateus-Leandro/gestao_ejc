import 'package:flutter/material.dart';
import 'package:gestao_ejc/components/buttons/custom_cancel_button.dart';
import 'package:gestao_ejc/components/buttons/custom_confirmation_button.dart';
import 'package:gestao_ejc/components/forms/custom_model_form.dart';
import 'package:gestao_ejc/models/encounter_model.dart';

class CustomExportQuadrantForm extends StatefulWidget {
  final EncounterModel encounter;
  const CustomExportQuadrantForm({super.key, required this.encounter});

  @override
  State<CustomExportQuadrantForm> createState() =>
      _CustomExportQuadrantFormState();
}

class _CustomExportQuadrantFormState extends State<CustomExportQuadrantForm> {
  final _formKey = GlobalKey<FormState>();
  bool _exporting = false;

  final List<Map<String, dynamic>> optionExport = [
    {
      'label': 'Exportar Todas Informações',
      'key': 'completeExport',
      'value': true,
    },
    {
      'label': 'Exportar Círculos',
      'key': 'circles',
      'value': true,
    },
    {
      'label': 'Exportar Equipes',
      'key': 'teams',
      'value': true,
    },
    {
      'label': 'Exportar Palestras',
      'key': 'lectures',
      'value': true,
    },
    {
      'label': 'Exportar fotos ',
      'key': 'photos',
      'value': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return CustomModelForm(
      title: 'Exportar Quadrante',
      formBody: _buildFormBody(),
      formKey: _formKey,
      actions: _buildFormActions(),
    );
  }

  List<Widget> _buildFormBody() {
    final bool completeExport =
        optionExport.firstWhere((e) => e['key'] == 'completeExport')['value'];

    return [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Opções da exportação',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ...optionExport.asMap().entries.map(
            (entry) {
              final index = entry.key;
              final option = entry.value;
              final key = option['key'];
              final isCompleteExport = key == 'completeExport';

              return _buildCheckBoxRow(
                option['label'],
                option['value'],
                (bool? newValue) {
                  setState(() {
                    optionExport[index]['value'] = newValue ?? false;

                    if (key == 'completeExport') {
                      final enabled = newValue ?? false;
                      for (var i = 0; i < optionExport.length; i++) {
                        if (optionExport[i]['key'] != 'completeExport') {
                          optionExport[i]['value'] = enabled;
                        }
                      }
                    }
                  });
                },
                !isCompleteExport && completeExport,
              );
            },
          ),
        ],
      ),
    ];
  }

  Widget _buildCheckBoxRow(
      String label, bool value, ValueChanged<bool?> onChanged,
      [bool disabled = false]) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: value,
          onChanged: disabled ? null : onChanged,
        ),
        Text(
          label,
          style: TextStyle(
            color: disabled ? Colors.grey : null,
          ),
        ),
      ],
    );
  }

  _buildFormActions() {
    return _exporting
        ? [
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: CircularProgressIndicator(),
              ),
            )
          ]
        : [
            CustomCancelButton(
              onPressed: () => Navigator.of(context).pop(),
            ),
            CustomConfirmationButton(
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  Navigator.of(context).pop();
                }
              },
            ),
          ];
  }
}
