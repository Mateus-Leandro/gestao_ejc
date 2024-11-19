import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gestao_ejc/components/buttons/custom_cancel_button.dart';
import 'package:gestao_ejc/components/buttons/custom_confirmation_button.dart';
import 'package:gestao_ejc/components/drawers/custom_color_drawer.dart';
import 'package:gestao_ejc/components/forms/custom_model_form.dart';
import 'package:gestao_ejc/controllers/circle_controller.dart';
import 'package:gestao_ejc/functions/function_color.dart';
import 'package:gestao_ejc/models/circle_model.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:gestao_ejc/theme/app_theme.dart';

class CustomCircleForm extends StatefulWidget {
  final CircleModel? circleModel;
  const CustomCircleForm({super.key, this.circleModel});

  @override
  State<CustomCircleForm> createState() => _CustomCircleFormState();
}

class _CustomCircleFormState extends State<CustomCircleForm> {
  late Color selectedColor;
  late String selectedColorHex;
  late String selectedColorName;
  final formKey = GlobalKey<FormState>();
  TextEditingController _minMembersController = TextEditingController();
  TextEditingController _maxMembersController = TextEditingController();
  final CircleController _circleController = getIt<CircleController>();
  final _appTheme = getIt<AppTheme>();
  final FunctionColor _functionColor = getIt<FunctionColor>();

  @override
  void initState() {
    super.initState();
    selectedColor = const Color(0xFFFF0000);
    selectedColorName = 'Vermelho';
    selectedColorHex = _functionColor.convertToHexadecimal(selectedColor);
    _minMembersController.text = '1';
    if (widget.circleModel != null) {
      selectedColor =
          _functionColor.getFromHexadecimal(widget.circleModel!.colorHex);
      selectedColorName = widget.circleModel!.id;
      selectedColorHex = widget.circleModel!.colorHex;
      _minMembersController.text = widget.circleModel!.minMembers.toString();
      _maxMembersController.text = widget.circleModel!.maxMembers.toString();
    }
  }

  @override
  void dispose() {
    _minMembersController.dispose();
    _maxMembersController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomModelForm(
      title: widget.circleModel != null ? 'Editar Círculo' : 'Criar Círculo',
      formKey: formKey,
      formBody: [
        const Text('Cor do círculo'),
        CustomColorDrawer(
          initialColor: selectedColor,
          colorSelected: (newColor) {
            setState(() {
              selectedColorName = newColor[0];
              selectedColor = newColor[1];
              selectedColorHex = newColor[2];
            });
          },
          tooltipMessage: 'Selecione a cor do círculo',
        ),
        TextFormField(
          controller: _minMembersController,
          keyboardType: const TextInputType.numberWithOptions(
              decimal: false, signed: false),
          decoration: const InputDecoration(labelText: 'Mínimo de pessoas'),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          maxLength: 2,
          textInputAction: TextInputAction.next,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Informe o mínimo de pessoas.';
            }
          },
        ),
        TextFormField(
            controller: _maxMembersController,
            keyboardType: const TextInputType.numberWithOptions(
                decimal: false, signed: false),
            decoration: const InputDecoration(labelText: 'Máximo de pessoas'),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            maxLength: 2,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Informe o máximo de pessoas.';
              }
            }),
      ],
      actions: [
        CustomCancelButton(
          onPressed: () => Navigator.of(context).pop(),
        ),
        CustomConfirmationButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              _saveCircle();
            }
          },
        ),
      ],
    );
  }

  void _saveCircle() async {
    CircleModel circle = CircleModel(
      id: selectedColorName,
      name: selectedColorName,
      colorHex: selectedColorHex,
      minMembers: int.parse(_minMembersController.text.trim()),
      maxMembers: int.parse(_maxMembersController.text.trim()),
    );

    String? result = await _circleController.saveCircle(circle: circle);
    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Círculo salvo com sucesso!'),
          backgroundColor: _appTheme.colorSnackBarSucess,
        ),
      );
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Erro ao salvar Círculo, tente novamente!'),
          backgroundColor: _appTheme.colorSnackBarErro,
        ),
      );
    }
  }
}
