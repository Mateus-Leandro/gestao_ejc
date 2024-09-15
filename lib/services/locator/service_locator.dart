import 'package:firebase_auth/firebase_auth.dart';
import 'package:gestao_ejc/services/auth_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  getIt.registerLazySingleton<AuthService>(() => AuthService());
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
}
