import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gestao_ejc/components/menu_drawer.dart';
import 'package:gestao_ejc/functions/function_screen.dart';
import 'package:gestao_ejc/helpers/date_format_string.dart';
import 'package:gestao_ejc/services/auth_service.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:gestao_ejc/theme/app_theme.dart';

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
  final AuthService authService = getIt<AuthService>();
  final FunctionScreen functionScreen = getIt<FunctionScreen>();
  final AppTheme appTheme = getIt<AppTheme>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuDrawer(indexMenuSelected: widget.indexMenuSelected),
      appBar: AppBar(
        foregroundColor: appTheme.colorTextTopBar,
        backgroundColor: appTheme.colorTopBar,
        title: Row(
          children: [
            Expanded(child: Text(widget.title)),
            Tooltip(
              message: "Sair do sistema",
              child: TextButton(
                onPressed: () {
                  functionScreen.callLogOut(context: context);
                },
                child: Column(
                  children: [
                    Text(
                      user.displayName ?? '',
                      style: TextStyle(fontSize: 17, color: appTheme.colorTextTopBar),
                    ),
                    Text(
                      dateString,
                      style: TextStyle(fontSize: 14, color: appTheme.colorTextTopBar),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
            decoration: BoxDecoration(
              color: appTheme.colorOuterFrame,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                decoration: BoxDecoration(
                  color: appTheme.colorInnerFrame,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: widget.body,
              ),
            )),
      ),
    );
  }
}
