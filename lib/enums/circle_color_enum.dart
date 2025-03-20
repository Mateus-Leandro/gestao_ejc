import 'package:flutter/material.dart';

enum CircleColorEnum {
  amarelo,
  azul,
  verde,
  vermelho,
  laranja,
  rosa,
  roxo,
  marrom,
}

extension CircleExtension on CircleColorEnum {
  String get colorHex {
    switch (this) {
      case CircleColorEnum.amarelo:
        return '0xFFFFFF00';
      case CircleColorEnum.azul:
        return '0xFF0000FF';
      case CircleColorEnum.verde:
        return '0xFF009000';
      case CircleColorEnum.vermelho:
        return '0xFFFF0000';
      case CircleColorEnum.laranja:
        return '0xFFFFA500';
      case CircleColorEnum.rosa:
        return '0xFFFFC0CB';
      case CircleColorEnum.roxo:
        return '0xFF800080';
      case CircleColorEnum.marrom:
        return '0xFFA52A2A';
    }
  }

  String get circleName {
    switch (this) {
      case CircleColorEnum.amarelo:
        return 'Amarelo';
      case CircleColorEnum.azul:
        return 'Azul';
      case CircleColorEnum.verde:
        return 'Verde';
      case CircleColorEnum.vermelho:
        return 'Vermelho';
      case CircleColorEnum.laranja:
        return 'Laranja';
      case CircleColorEnum.rosa:
        return 'Rosa';
      case CircleColorEnum.roxo:
        return 'Roxo';
      case CircleColorEnum.marrom:
        return 'Marrom';
    }
  }

  Color get circleColor {
    switch (this) {
      case CircleColorEnum.amarelo:
        return Colors.yellow;
      case CircleColorEnum.azul:
        return Colors.blue;
      case CircleColorEnum.verde:
        return Colors.green;
      case CircleColorEnum.vermelho:
        return Colors.red;
      case CircleColorEnum.laranja:
        return Colors.orange;
      case CircleColorEnum.rosa:
        return Colors.pink;
      case CircleColorEnum.roxo:
        return Colors.purple;
      case CircleColorEnum.marrom:
        return Colors.brown;
    }
  }

  Widget get iconColor {
    return Container(
      height: 24,
      width: 24,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        color: circleColor,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
