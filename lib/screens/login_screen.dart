import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gestao_ejc/screens/password_reset_modal.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = getIt<AuthService>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  String? logoUrl;
  String? roseUrl;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              color: Theme.of(context).primaryColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  roseUrl != null
                      ? Image.network(
                          roseUrl!,
                        )
                      : const CircularProgressIndicator(),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  logoUrl != null
                      ? Image.network(
                          logoUrl!,
                          height: 300,
                          width: 400,
                          fit: BoxFit.fill,
                        )
                      : const CircularProgressIndicator(),
                  Container(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        TextField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        TextField(
                          controller: _senhaController,
                          decoration: const InputDecoration(
                            labelText: 'Senha',
                          ),
                          obscureText: true,
                        ),
                        const SizedBox(height: 30),
                        TextButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return const PasswordResetModal();
                                });
                          },
                          child: const Text('Esqueci minha senha.'),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {
                            _authService
                                .logIn(
                                    email: _emailController.text,
                                    senha: _senhaController.text)
                                .then((String? error) {
                              if (error != null) {
                                final snackBar = SnackBar(
                                    content: Text(error),
                                    backgroundColor: Colors.red);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Theme.of(context).primaryColor,
                              fixedSize: const Size(220, 60)),
                          child: const Text('Acessar'),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _loadImages() async {
    try {
      final List<String> imagePaths = [
        "images/app/logos/logo02.png",
        "images/app/roses/rosa02.png"
      ];

      final List<String> urls = await Future.wait(imagePaths.map((path) async {
        final Reference ref = FirebaseStorage.instance.ref().child(path);
        return await ref.getDownloadURL();
      }).toList());

      setState(() {
        logoUrl = urls[0];
        roseUrl = urls[1];
      });
    } catch (e) {
      print('Erro ao carregar imagens: $e');
    }
  }
}
