import 'package:flutter/material.dart';

class CircleColors {
  final Map<String, Color> _colors = const {
    "Amarelo": Color(0xFFFFFF00),
    "Azul": Color(0xFF0000FF),
    "Verde": Color(0xFF009000),
    "Vermelho": Color(0xFFFF0000),
    "Laranja": Color(0xFFFFA500),
    "Rosa": Color(0xFFFFC0CB),
    "Roxo": Color(0xFF800080),
    "Marrom": Color(0xFFA52A2A),
  };

  Map<String, Color> get currentColors => _colors;
}
