import 'package:flutter/material.dart';

class CustomEditButton extends StatelessWidget {
  final Widget form;
  const CustomEditButton({super.key, required this.form});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return form;
            },
          );
        },
        icon: const Icon(Icons.edit));
  }
}
