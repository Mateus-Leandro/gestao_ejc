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

extension SetorExtension on TeamTypeEnum {
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
}
