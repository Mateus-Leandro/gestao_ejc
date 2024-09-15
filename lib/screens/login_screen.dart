import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthService authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Row(
          children: [
            Container(
              color: Colors.indigo,
              width: 400,
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FlutterLogo(
                      size: 350,
                      style: FlutterLogoStyle.stacked,
                    ),
                    Container(
                      padding: EdgeInsets.all(30),
                      child: Column(
                        children: [
                          SizedBox(height: 40),
                          TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          TextField(
                            controller: _senhaController,
                            decoration: InputDecoration(
                              labelText: 'Senha',
                            ),
                            obscureText: true,
                          ),
                          SizedBox(height: 30),
                          TextButton(
                            onPressed: () {
                            },
                            child: Text('Esqueci minha senha.'),
                          ),
                          SizedBox(height: 30),
                          ElevatedButton(
                            onPressed: () {
                              authService
                                  .entrarUsuario(
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
                            child: Text('Acessar'),
                            style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.indigo,
                                fixedSize: Size(220, 60)),
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
      ),
    );
  }
}
