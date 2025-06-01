import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pet_model.dart'; //Para importar a classe PetModel para tipar os dados recebidos e enviados...

class ApiService {
  //Aqui vou inserir as classes que contem os métodos para interagir com minha api.
  static const String _baseUrl = 'http://10.0.2.2:3000/dadosPets';

  Future<List<PetModel>> getPets() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        List<PetModel> dadosPets = body
            .map((dynamic item) => PetModel.fromJson(item))
            .toList();
        return dadosPets;
      } else {
        throw Exception(
          'Erro ao carregar dados dos Pets: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Falha ao se conectar ao servidor: $e');
    }
  }
}
