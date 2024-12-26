import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gestao_ejc/components/SnackBars/custom_snack_bar.dart';
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
  const CustomCircleForm({
    super.key,
  });

  @override
  State<CustomCircleForm> createState() => _CustomCircleFormState();
}

class _CustomCircleFormState extends State<CustomCircleForm> {
  late Color selectedColor;
  late String selectedColorHex;
  late String selectedColorName;
  final formKey = GlobalKey<FormState>();
  final CircleController _circleController = getIt<CircleController>();
  final _appTheme = getIt<AppTheme>();
  final FunctionColor _functionColor = getIt<FunctionColor>();

  @override
  void initState() {
    super.initState();
    selectedColor = const Color(0xFFFF0000);
    selectedColorName = 'Vermelho';
    selectedColorHex = _functionColor.convertToHexadecimal(selectedColor);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomModelForm(
      title: 'Criar Círculo',
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
      id: selectedColorName.toLowerCase(),
      name: selectedColorName,
      colorHex: selectedColorHex,
    );

    try {
      await _circleController.saveCircle(circle: circle);
      CustomSnackBar.show(
        context: context,
        message: 'Círculo salvo com sucesso!',
        colorBar: Colors.green,
      );
    } catch (e) {
      CustomSnackBar.show(
        context: context,
        message: e.toString(),
        colorBar: Colors.red,
      );
    } finally {
      Navigator.of(context).pop();
    }
  }
}
