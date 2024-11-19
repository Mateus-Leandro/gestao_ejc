import 'package:flutter/material.dart';
import 'package:gestao_ejc/functions/function_color.dart';
import 'package:gestao_ejc/models/circle_colors.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';

class CustomColorDrawer extends StatefulWidget {
  final Color initialColor;
  final ValueChanged<List> colorSelected;
  final String tooltipMessage;

  const CustomColorDrawer({
    Key? key,
    required this.initialColor,
    required this.colorSelected,
    required this.tooltipMessage,
  }) : super(key: key);

  @override
  State<CustomColorDrawer> createState() => _CustomColorDrawerState();
}

class _CustomColorDrawerState extends State<CustomColorDrawer> {
  late Color _currentColor;
  final FunctionColor functionColor = getIt<FunctionColor>();
  final CircleColors _circleColors = CircleColors();
  String? colorName;

  @override
  void initState() {
    super.initState();
    _currentColor = widget.initialColor;
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltipMessage,
      child: DropdownButton<Color>(
        focusColor: Colors.transparent,
        value: _currentColor,
        icon: const Icon(Icons.arrow_drop_down),
        items: _circleColors.currentColors.entries.map((color) {
          return DropdownMenuItem<Color>(
            value: color.value,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: color.value,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  width: 24,
                  height: 24,
                  margin: const EdgeInsets.only(right: 8),
                ),
                Text(color.key),
              ],
            ),
          );
        }).toList(),
        onChanged: (color) {
          if (color != null) {
            setState(() {
              _currentColor = color;
            });
            colorName = _circleColors.currentColors.entries
                .firstWhere((element) => element.value == color)
                .key;
            widget.colorSelected([
              colorName,
              color,
              functionColor.convertToHexadecimal(color),
            ]);
          }
        },
      ),
    );
  }
}
