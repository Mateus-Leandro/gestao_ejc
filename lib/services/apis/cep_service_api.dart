import 'dart:convert';
import 'package:http/http.dart' as http;

class CepServiceApi {
  static Future<Map<String, dynamic>?> zipCodeSearch(String cep) async {
    final url = Uri.parse('https://viacep.com.br/ws/$cep/json/');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.containsKey("erro")) {
          throw Error();
        }
        return data;
      }
    } catch (e) {
      rethrow;
    }
  }
}
