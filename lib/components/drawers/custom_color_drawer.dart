import 'package:flutter/material.dart';
import 'package:gestao_ejc/enums/circle_color_enum.dart';

class CustomColorDrawer extends StatefulWidget {
  final CircleColorEnum? initialColor;
  final ValueChanged<CircleColorEnum> colorSelected;
  final String tooltipMessage;
  final bool allowSelection;

  const CustomColorDrawer({
    Key? key,
    required this.initialColor,
    required this.colorSelected,
    required this.tooltipMessage,
    required this.allowSelection,
  }) : super(key: key);

  @override
  State<CustomColorDrawer> createState() => _CustomColorDrawerState();
}

class _CustomColorDrawerState extends State<CustomColorDrawer> {
  late CircleColorEnum? _currentColor;
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
      child: DropdownButton<CircleColorEnum>(
        focusColor: Colors.transparent,
        value: _currentColor,
        icon: const Icon(Icons.arrow_drop_down),
        items: CircleColorEnum.values.map((CircleColorEnum color) {
          return DropdownMenuItem<CircleColorEnum>(
            value: color,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                color.iconColor,
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(color.circleName),
                ),
              ],
            ),
          );
        }).toList(),
        onChanged: widget.allowSelection
            ? (color) {
                if (color != null) {
                  setState(() {
                    _currentColor = color;
                  });
                  widget.colorSelected(color);
                }
              }
            : null,
      ),
    );
  }
}
