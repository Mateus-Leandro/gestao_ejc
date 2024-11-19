import 'package:flutter/material.dart';

class CircleColors {
  final Map<String, Color> _colors = const {
    "Vermelho": Color(0xFFFF0000),
    "Verde": Color(0xFF00FF00),
    "Azul": Color(0xFF0000FF),
    "Amarelo": Color(0xFFFFFF00),
    "Roxo": Color(0xFF800080),
    "Branco": Color(0xFFFFFFFF),
  };

  Map<String, Color> get currentColors => _colors;
}
