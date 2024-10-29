import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gestao_ejc/controllers/encounter_controller.dart';
import 'package:gestao_ejc/controllers/financial_controller.dart';
import 'package:gestao_ejc/controllers/financial_index_controller.dart';
import 'package:gestao_ejc/controllers/user_controller.dart';
import 'package:gestao_ejc/functions/function_call_email_app.dart';
import 'package:gestao_ejc/functions/function_call_url.dart';
import 'package:gestao_ejc/functions/function_date.dart';
import 'package:gestao_ejc/functions/function_decimal_place.dart';
import 'package:gestao_ejc/functions/function_int_to_roman.dart';
import 'package:gestao_ejc/functions/function_mask_decimal.dart';
import 'package:gestao_ejc/functions/function_reports.dart';
import 'package:gestao_ejc/functions/function_screen.dart';
import 'package:gestao_ejc/services/auth_service.dart';
import 'package:gestao_ejc/services/encounter_service.dart';
import 'package:gestao_ejc/services/financial_index_service.dart';
import 'package:gestao_ejc/services/financial_service.dart';
import 'package:gestao_ejc/services/pdf_service.dart';
import 'package:gestao_ejc/services/user_service.dart';
import 'package:gestao_ejc/services/xlsx_service.dart';
import 'package:gestao_ejc/theme/app_theme.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  getIt.registerLazySingleton<AuthService>(() => AuthService());
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FunctionDate>(() => FunctionDate());
  getIt.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance);
  getIt.registerLazySingleton<UserService>(() => UserService());
  getIt.registerLazySingleton<UserController>(() => UserController());
  getIt.registerLazySingleton<FunctionScreen>(() => FunctionScreen());
  getIt.registerLazySingleton<FunctionCallUrl>(() => FunctionCallUrl());
  getIt.registerLazySingleton<FunctionCallEmailApp>(
      () => FunctionCallEmailApp());
  getIt.registerLazySingleton<AppTheme>(() => AppTheme());
  getIt.registerLazySingleton<FinancialService>(() => FinancialService());
  getIt.registerLazySingleton<FinancialController>(() => FinancialController());
  getIt.registerLazySingleton<FinancialIndexService>(
      () => FinancialIndexService());
  getIt.registerLazySingleton<FinancialIndexController>(
      () => FinancialIndexController());
  getIt.registerLazySingleton<FunctionMaskDecimal>(() => FunctionMaskDecimal());
  getIt.registerLazySingleton<FunctionDecimalPlace>(
      () => FunctionDecimalPlace());
  getIt.registerLazySingleton<FunctionReports>(() => FunctionReports());
  getIt.registerLazySingleton<PdfService>(() => PdfService());
  getIt.registerLazySingleton<XlsxService>(() => XlsxService());
  getIt.registerLazySingleton<EncounterService>(() => EncounterService());
  getIt.registerLazySingleton<EncounterController>(() => EncounterController());
  getIt.registerLazySingleton<FunctionIntToRoman>(() => FunctionIntToRoman());
}
