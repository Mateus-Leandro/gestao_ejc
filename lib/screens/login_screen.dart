import 'package:flutter/material.dart';
import 'package:gestao_ejc/functions/function_image_from_storage.dart';
import 'package:gestao_ejc/components/custom_text_form_field.dart';
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
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _visiblePassword = false;
  bool _acessing = false;

  @override
  void initState() {
    super.initState();
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
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FunctionImageFromStorage(
                      imagePath: "images/app/roses/rosa02.png"),
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
                  FunctionImageFromStorage(
                      imagePath: "images/app/logos/logo02.png"),
                  Container(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          CustomTextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                            ),
                            validator: (value) {
                              return value!.isEmpty
                                  ? 'Informe seu email'
                                  : null;
                            },
                            obscure: false,
                            functionSubimitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_passwordFocusNode);
                            },
                          ),
                          CustomTextFormField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                labelText: 'Senha',
                                suffixIcon: IconButton(
                                  icon: Icon(_visiblePassword
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: () {
                                    _seePassword();
                                  },
                                ),
                              ),
                              validator: (value) {
                                return value!.isEmpty
                                    ? 'Informe sua senha'
                                    : null;
                              },
                              obscure: !_visiblePassword,
                              functionSubimitted: (_) {
                                _login();
                              },
                              focusNode: _passwordFocusNode),
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
                          !_acessing
                              ? ElevatedButton(
                                  onPressed: () {
                                    _login();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      fixedSize: const Size(220, 60)),
                                  child: const Text('Acessar'),
                                )
                              : CircularProgressIndicator(),
                        ],
                      ),
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

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      if (mounted) {
        setState(() {
          _acessing = true;
        });
      }

      try {
        String? error = await _authService.logIn(
          email: _emailController.text.trim(),
          senha: _passwordController.text,
        );

        if (error != null) {
          final snackBar = SnackBar(
            content: Text(error),
            backgroundColor: Colors.red,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } catch (e) {
        const snackBar = SnackBar(
          content: Text('Ocorreu um erro ao tentar fazer login.'),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } finally {
        if (mounted) {
          setState(() {
            _acessing = false;
          });
        }
      }
    }
  }

  void _seePassword() {
    setState(() {
      _visiblePassword = !_visiblePassword;
    });
  }
}
