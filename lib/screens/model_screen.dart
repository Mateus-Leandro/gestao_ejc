import 'package:flutter/material.dart';
import 'package:gestao_ejc/components/menu_drawer.dart';
import 'package:gestao_ejc/helpers/date_format_string.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';

class ModelScreen extends StatefulWidget {
  final String title;
  final Widget body;

  const ModelScreen({super.key, required this.title, required this.body});

  @override
  State<ModelScreen> createState() => _ModelScreenState();
}

class _ModelScreenState extends State<ModelScreen> {
  String dateString = getIt<DateFormatString>().getDate();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MenuDrawer(),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).primaryColor,
        title: Row(
          children: [
            Text(widget.title),
            Spacer(),
            Text(dateString),
          ],
        ),
      ),
      body: widget.body,
    );
  }
}
