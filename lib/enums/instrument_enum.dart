enum InstrumentEnum {
  violao,
  violino,
  teclado,
  bateria,
  cavaco,
  cajon,
  canto,
  escaleta,
  gaita,
}

extension InstrumentEnumExtension on InstrumentEnum {
  String get instrumentName {
    switch (this) {
      case InstrumentEnum.canto:
        return 'Canto';
      case InstrumentEnum.violao:
        return 'Violão';
      case InstrumentEnum.bateria:
        return 'Bateria';
      case InstrumentEnum.teclado:
        return 'Teclado';
      case InstrumentEnum.cavaco:
        return 'Cavaco';
      case InstrumentEnum.cajon:
        return 'Cajon';
      case InstrumentEnum.escaleta:
        return 'Escaleta';
      case InstrumentEnum.gaita:
        return 'Gaita';
      case InstrumentEnum.violino:
        return 'Violino';
    }
  }

  static InstrumentEnum fromName(String name) {
    return InstrumentEnum.values.firstWhere(
      (element) => element.instrumentName == name,
      orElse: () => throw Exception('Instrumento inválido: $name'),
    );
  }
}
