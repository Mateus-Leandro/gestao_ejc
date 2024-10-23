import 'package:flutter/material.dart';

class CustomListTile extends StatefulWidget {
  final ListTile listTile;
  final Color defaultBackgroundColor;

  const CustomListTile(
      {super.key,
      required this.listTile,
      required this.defaultBackgroundColor});

  @override
  State<CustomListTile> createState() => _CustomListTileState();
}

class _CustomListTileState extends State<CustomListTile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Color hoverBackgroundColor = Colors.grey[300]!;
  late Color defaultBackgroundColor;

  @override
  Widget build(BuildContext context) {
    defaultBackgroundColor = widget.defaultBackgroundColor;
    ValueNotifier<Color> backgroundColorNotifier =
        ValueNotifier(defaultBackgroundColor);

    return MouseRegion(
      onEnter: (_) {
        backgroundColorNotifier.value = hoverBackgroundColor;
      },
      onExit: (_) {
        backgroundColorNotifier.value = defaultBackgroundColor;
      },
      child: ValueListenableBuilder<Color>(
        valueListenable: backgroundColorNotifier,
        builder: (context, backgroundColor, child) {
          return Container(
            color: backgroundColor,
            child: widget.listTile,
          );
        },
      ),
    );
  }
}
