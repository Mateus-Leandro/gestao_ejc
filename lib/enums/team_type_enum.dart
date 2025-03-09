import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum TeamTypeEnum {
  apoioEAcolhida,
  cafezinho,
  compras,
  cozinha,
  coordenacaoGeral,
  dirigentes,
  garcoms,
  liturgiaExterna,
  liturgiaInterna,
  ordemELimpeza,
  sala,
  secretaria,
  tiosDaExterna,
}

extension TeamExtension on TeamTypeEnum {
  String get formattedName {
    switch (this) {
      case TeamTypeEnum.apoioEAcolhida:
        return 'Apoio e Acolhida';
      case TeamTypeEnum.cafezinho:
        return 'Cafezinho';
      case TeamTypeEnum.compras:
        return 'Compras';
      case TeamTypeEnum.cozinha:
        return 'Cozinha';
      case TeamTypeEnum.coordenacaoGeral:
        return 'Coordenação Geral';
      case TeamTypeEnum.dirigentes:
        return 'Dirigentes';
      case TeamTypeEnum.garcoms:
        return 'Garçom';
      case TeamTypeEnum.liturgiaExterna:
        return 'Liturgia Externa';
      case TeamTypeEnum.liturgiaInterna:
        return 'Liturgia Interna';
      case TeamTypeEnum.ordemELimpeza:
        return 'Ordem e Limpeza';
      case TeamTypeEnum.sala:
        return 'Sala';
      case TeamTypeEnum.secretaria:
        return 'Secretaria';
      case TeamTypeEnum.tiosDaExterna:
        return 'Tios da Externa';
    }
  }

  get teamIcon {
    switch (this) {
      case TeamTypeEnum.apoioEAcolhida:
        return const FaIcon(Icons.volunteer_activism);
      case TeamTypeEnum.cafezinho:
        return const FaIcon(Icons.coffee);
      case TeamTypeEnum.compras:
        return const FaIcon(Icons.payments_outlined);
      case TeamTypeEnum.cozinha:
        return const FaIcon(Icons.soup_kitchen_outlined);
      case TeamTypeEnum.coordenacaoGeral:
        return const FaIcon(FontAwesomeIcons.gear);
      case TeamTypeEnum.dirigentes:
        return const FaIcon(Icons.emoji_people_outlined);
      case TeamTypeEnum.garcoms:
        return const FaIcon(Icons.room_service_outlined);
      case TeamTypeEnum.liturgiaExterna:
        return const FaIcon(Icons.book);
      case TeamTypeEnum.liturgiaInterna:
        return const Icon(Icons.church);
      case TeamTypeEnum.ordemELimpeza:
        return const FaIcon(Icons.clean_hands_rounded);
      case TeamTypeEnum.sala:
        return const FaIcon(Icons.door_back_door_outlined);
      case TeamTypeEnum.secretaria:
        return const FaIcon(Icons.monitor);
      case TeamTypeEnum.tiosDaExterna:
        return const Icon(EvaIcons.car);
    }
  }
}
