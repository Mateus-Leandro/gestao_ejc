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
        return Image.asset('assets/icons/apoio_e_acolhida.png',
            width: 24, height: 24);
      case TeamTypeEnum.cafezinho:
        return Image.asset('assets/icons/cafezinho.png', width: 24, height: 24);
      case TeamTypeEnum.compras:
        return Image.asset('assets/icons/compras.png', width: 24, height: 24);
      case TeamTypeEnum.cozinha:
        return Image.asset('assets/icons/cozinha.png', width: 24, height: 24);
      case TeamTypeEnum.coordenacaoGeral:
        return Image.asset('assets/icons/coordenacao_geral.png',
            width: 24, height: 24);
      case TeamTypeEnum.dirigentes:
        return Image.asset('assets/icons/dirigentes.png',
            width: 24, height: 24);
      case TeamTypeEnum.garcoms:
        return Image.asset('assets/icons/garcom.png', width: 24, height: 24);
      case TeamTypeEnum.liturgiaExterna:
        return Image.asset('assets/icons/liturgia_externa.png',
            width: 24, height: 24);
      case TeamTypeEnum.liturgiaInterna:
        return Image.asset('assets/icons/liturgia_interna.png',
            width: 24, height: 24);
      case TeamTypeEnum.ordemELimpeza:
        return Image.asset('assets/icons/ordem_e_limpeza.png',
            width: 24, height: 24);
      case TeamTypeEnum.sala:
        return Image.asset('assets/icons/sala.png', width: 24, height: 24);
      case TeamTypeEnum.secretaria:
        return Image.asset('assets/icons/secretaria.png',
            width: 24, height: 24);
      case TeamTypeEnum.tiosDaExterna:
        return Image.asset('assets/icons/tios_da_externa.png',
            width: 24, height: 24);
    }
  }
}
