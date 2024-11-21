import 'package:flutter/material.dart';

class CustomModelForm extends StatefulWidget {
  final String title;
  final formKey;
  final List<Widget> formBody;
  final List<Widget>? actions;
  const CustomModelForm({
    super.key,
    required this.title,
    required this.formKey,
    required this.formBody,
    required this.actions,
  });

  @override
  State<CustomModelForm> createState() => _CustomModelFormState();
}

class _CustomModelFormState extends State<CustomModelForm> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Column(
        children: [Text(widget.title), const Divider()],
      ),
      content: SingleChildScrollView(
        child: Form(
          key: widget.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: widget.formBody,
          ),
        ),
      ),
      actions: widget.actions,
    );
  }
}
