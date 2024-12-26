import 'package:flutter/material.dart';
import 'package:gestao_ejc/components/SnackBars/custom_snack_bar.dart';
import 'package:gestao_ejc/controllers/auth_controller.dart';
import 'package:gestao_ejc/screens/password_reset_modal.dart';
import 'package:gestao_ejc/services/locator/service_locator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController _authController = getIt<AuthController>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
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
                  Image(
                    image: AssetImage('assets/images/roses/rose02.png'),
                  ),
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
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: const Image(
                      image: AssetImage('assets/images/logos/logo02.png'),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                            ),
                            validator: (value) {
                              return value!.isEmpty
                                  ? 'Informe seu email'
                                  : null;
                            },
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.username],
                          ),
                          TextFormField(
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
                            obscureText: !_visiblePassword,
                            onFieldSubmitted: (_) {
                              _login();
                            },
                            autofillHints: const [AutofillHints.password],
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
        await _authController.logIn(
          email: _emailController.text.trim(),
          senha: _passwordController.text,
        );
      } catch (e) {
        CustomSnackBar.show(
          context: context,
          message: e.toString(),
          colorBar: Colors.red,
        );
      }
      if (mounted) {
        setState(() {
          _acessing = false;
        });
      }
    }
  }

  void _seePassword() {
    setState(() {
      _visiblePassword = !_visiblePassword;
    });
  }
}
