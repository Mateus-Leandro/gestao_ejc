import 'package:flutter/material.dart';

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
  salaImagens,
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
      case TeamTypeEnum.salaImagens:
        return 'Sala Imagens';
      case TeamTypeEnum.secretaria:
        return 'Secretaria';
      case TeamTypeEnum.tiosDaExterna:
        return 'Tios da Externa';
    }
  }

  Icon get teamIcon {
    switch (this) {
      case TeamTypeEnum.apoioEAcolhida:
        return const Icon(Icons.volunteer_activism);
      case TeamTypeEnum.cafezinho:
        return const Icon(Icons.coffee);
      case TeamTypeEnum.compras:
        return const Icon(Icons.payments_outlined);
      case TeamTypeEnum.cozinha:
        return const Icon(Icons.soup_kitchen_outlined);
      case TeamTypeEnum.coordenacaoGeral:
        return const Icon(Icons.settings_accessibility);
      case TeamTypeEnum.dirigentes:
        return const Icon(Icons.emoji_people_outlined);
      case TeamTypeEnum.garcoms:
        return const Icon(Icons.room_service_outlined);
      case TeamTypeEnum.liturgiaExterna:
        return const Icon(Icons.book);
      case TeamTypeEnum.liturgiaInterna:
        return const Icon(Icons.church);
      case TeamTypeEnum.ordemELimpeza:
        return const Icon(Icons.clean_hands_rounded);
      case TeamTypeEnum.salaImagens:
        return const Icon(Icons.photo_album);
      case TeamTypeEnum.secretaria:
        return const Icon(Icons.monitor);
      case TeamTypeEnum.tiosDaExterna:
        return const Icon(Icons.people);
    }
  }
}
