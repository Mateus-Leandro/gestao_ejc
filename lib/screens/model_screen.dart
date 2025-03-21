import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gestao_ejc/components/drawers/custom_menu_drawer.dart';
import 'package:gestao_ejc/controllers/auth_controller.dart';
import 'package:gestao_ejc/functions/function_date.dart';
import 'package:gestao_ejc/functions/function_screen.dart';
import 'package:gestao_ejc/services/auth_service.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:gestao_ejc/theme/app_theme.dart';
import 'package:quickalert/quickalert.dart';

class ModelScreen extends StatefulWidget {
  final String title;
  final Widget body;
  final int? indexMenuSelected;
  final bool showMenuDrawer;

  const ModelScreen({
    super.key,
    required this.title,
    required this.body,
    required this.indexMenuSelected,
    required this.showMenuDrawer,
  });

  @override
  State<ModelScreen> createState() => _ModelScreenState();
}

class _ModelScreenState extends State<ModelScreen> {
  String dateString = getIt<FunctionDate>().getActualDateToString();
  final User user = getIt<FirebaseAuth>().currentUser!;
  final AuthController authController = getIt<AuthController>();
  final AuthService authService = getIt<AuthService>();
  final FunctionScreen functionScreen = getIt<FunctionScreen>();
  final AppTheme appTheme = getIt<AppTheme>();

  bool _alertShown = false;

  @override
  void initState() {
    super.initState();
    _initializeActualUserModel();
  }

  @override
  Widget build(BuildContext context) {
    if (authService.actualUserModel == null) {
      return const Center(child: CircularProgressIndicator());
    }

    bool hasPermission = authController.userHasPermission(
        context: context, user: authService.actualUserModel!);

    if (hasPermission) {
      return Scaffold(
        drawer: widget.showMenuDrawer
            ? CustomMenuDrawer(indexMenuSelected: widget.indexMenuSelected)
            : null,
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
                        style: TextStyle(
                            fontSize: 17, color: appTheme.colorTextTopBar),
                      ),
                      Text(
                        dateString,
                        style: TextStyle(
                            fontSize: 14, color: appTheme.colorTextTopBar),
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
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: widget.body,
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      if (!_alertShown) {
        _alertShown = true;
        if (mounted) {
          Future.delayed(Duration.zero, () {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              title: 'Acesso Negado',
              text: 'Entre em contato com a equipe dirigente!',
              confirmBtnText: 'OK',
              barrierDismissible: false,
              onConfirmBtnTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/', (Route<dynamic> route) => false);
                if (!authService.actualUserModel!.active) {
                  functionScreen.callLogOut(context: context);
                }
              },
            );
          });
        }
      }
      return const Center(child: CircularProgressIndicator());
    }
  }

  Future<void> _initializeActualUserModel() async {
    await authService.getActualUserModel;
    if (mounted) {
      setState(() {});
    }
  }
}
