import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gestao_ejc/components/menu_drawer.dart';
import 'package:gestao_ejc/helpers/date_format_string.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';

class ModelScreen extends StatefulWidget {
  final String title;
  final Widget body;
  final int? indexMenuSelected;

  const ModelScreen({
    super.key,
    required this.title,
    required this.body,
    required this.indexMenuSelected,
  });

  @override
  State<ModelScreen> createState() => _ModelScreenState();
}

class _ModelScreenState extends State<ModelScreen> {
  String dateString = getIt<DateFormatString>().getDate();
  final User user = getIt<FirebaseAuth>().currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuDrawer(indexMenuSelected: widget.indexMenuSelected),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).primaryColor,
        title: Row(
          children: [
            Expanded(child: Text(widget.title)),
            Column(
              children: [
                Text(user.displayName ?? '', style: const TextStyle(fontSize: 17)),
                Text(dateString, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ],
        ),
      ),
      body: widget.body,
    );
  }
}
