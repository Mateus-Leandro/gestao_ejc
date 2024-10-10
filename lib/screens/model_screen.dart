import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gestao_ejc/components/custom_menu_drawer.dart';
import 'package:gestao_ejc/functions/function_screen.dart';
import 'package:gestao_ejc/helpers/date_format_string.dart';
import 'package:gestao_ejc/services/auth_service.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import 'package:gestao_ejc/theme/app_theme.dart';
import 'package:quickalert/quickalert.dart';

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

    String? ret = authService.userHasPermission(
        context: context, user: authService.actualUserModel!);

    if (ret == null) {
      return Scaffold(
        drawer: CustomMenuDrawer(indexMenuSelected: widget.indexMenuSelected),
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
                child: widget.body,
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
              text: '${ret} Entre em contato com a equipe dirigente!',
              confirmBtnText: 'OK',
              barrierDismissible: false,
              onConfirmBtnTap: () {
                Navigator.of(context).pop();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
                if (!authService.actualUserModel!.active) {
                  authService.logOut();
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
    AuthService authService = getIt<AuthService>();
    await authService.getActualUserModel;
    if (mounted) {
      setState(() {});
    }
  }
}
