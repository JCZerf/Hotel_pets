import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pet_model.dart';

class ApiService {
  static const String _baseUrl = 'http://10.0.2.2:3000';

  // GET - Buscar lista de pets
  Future<List<PetModel>> getPets() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/dadosPets'));

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

  // POST - Adicionar novo pet
  Future<PetModel> addPet(PetModel pet) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/dadosPets'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(pet.toJson()),
      );

      if (response.statusCode == 201) {
        return PetModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Falha ao adicionar pet: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Falha ao conectar ao servidor: $e');
    }
  }

  // PUT - Atualizar pet existente
  Future<PetModel> updatePet(String id, PetModel pet) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/dadosPets/$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(pet.toJson()),
      );

      if (response.statusCode == 200) {
        return PetModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Falha ao atualizar pet: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Falha ao conectar ao servidor: $e');
    }
  }

  // DELETE - Excluir pet
  Future<void> deletePet(String id) async {
    try {
      final response = await http.delete(Uri.parse('$_baseUrl/dadosPets/$id'));

      if (response.statusCode == 200 || response.statusCode == 204) {
        return; // Sucesso
      } else {
        throw Exception('Falha ao excluir pet: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Falha ao conectar ao servidor: $e');
    }
  }
}
