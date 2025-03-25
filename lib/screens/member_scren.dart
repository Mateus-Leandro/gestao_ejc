import 'package:flutter/material.dart';
import 'package:gestao_ejc/screens/model_screen.dart';

class MemberScren extends StatefulWidget {
  const MemberScren({super.key});

  @override
  State<MemberScren> createState() => _MemberScrenState();
}

class _MemberScrenState extends State<MemberScren> {
  @override
  Widget build(BuildContext context) {
    return ModelScreen(
      title: 'Membros',
      body: Container(),
      indexMenuSelected:1,
      showMenuDrawer: true,
    );
  }
}
