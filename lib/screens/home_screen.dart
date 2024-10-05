import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gestao_ejc/screens/model_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ModelScreen(
      title: 'Gestão EJC',
      body: Center(
        child: Text(
          "Seja Bem vindo ${FirebaseAuth.instance.currentUser?.displayName ?? ''}",
        ),
      ), indexMenuSelected: null,
    );
  }
}
