import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gestao_ejc/controllers/auth_controller.dart';
import 'package:gestao_ejc/controllers/circle_controller.dart';
import 'package:gestao_ejc/controllers/circle_member_controller.dart';
import 'package:gestao_ejc/controllers/encounter_controller.dart';
import 'package:gestao_ejc/controllers/financial_controller.dart';
import 'package:gestao_ejc/controllers/financial_index_controller.dart';
import 'package:gestao_ejc/controllers/member_controller.dart';
import 'package:gestao_ejc/controllers/user_controller.dart';
import 'package:gestao_ejc/functions/function_call_email_app.dart';
import 'package:gestao_ejc/functions/function_call_url.dart';
import 'package:gestao_ejc/functions/function_color.dart';
import 'package:gestao_ejc/functions/function_date.dart';
import 'package:gestao_ejc/functions/function_decimal_place.dart';
import 'package:gestao_ejc/functions/function_input_text.dart';
import 'package:gestao_ejc/functions/function_int_to_roman.dart';
import 'package:gestao_ejc/functions/function_mask_decimal.dart';
import 'package:gestao_ejc/functions/function_music_icon.dart';
import 'package:gestao_ejc/functions/function_pick_image.dart';
import 'package:gestao_ejc/functions/function_reports.dart';
import 'package:gestao_ejc/functions/function_screen.dart';
import 'package:gestao_ejc/services/auth_service.dart';
import 'package:gestao_ejc/services/circle_member_service.dart';
import 'package:gestao_ejc/services/circle_service.dart';
import 'package:gestao_ejc/services/encounter_service.dart';
import 'package:gestao_ejc/services/financial_index_service.dart';
import 'package:gestao_ejc/services/financial_service.dart';
import 'package:gestao_ejc/services/firebase_storage_service.dart';
import 'package:gestao_ejc/services/member_service.dart';
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
  getIt.registerLazySingleton<FunctionInputText>(() => FunctionInputText());
  getIt.registerLazySingleton<FunctionMusicIcon>(() => FunctionMusicIcon());
  getIt.registerLazySingleton<FirebaseStorageService>(
      () => FirebaseStorageService());
  getIt.registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);
  getIt.registerLazySingleton<FunctionPickImage>(() => FunctionPickImage());
  getIt.registerLazySingleton<CircleService>(() => CircleService());
  getIt.registerLazySingleton<CircleController>(() => CircleController());
  getIt.registerLazySingleton<FunctionColor>(() => FunctionColor());
  getIt.registerLazySingleton<CircleMemberController>(
      () => CircleMemberController());
  getIt.registerLazySingleton<CircleMemberService>(() => CircleMemberService());
  getIt.registerLazySingleton<AuthController>(() => AuthController());
  getIt.registerLazySingleton<MemberController>(() => MemberController());
  getIt.registerLazySingleton<MemberService>(() => MemberService());
}
