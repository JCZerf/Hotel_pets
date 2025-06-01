import 'dart:convert';
import 'package:flutter/foundation.dart';

class PetModel {
  final String? id; // Identificador como String (conversão garantida)
  final String nomeTutor;
  final String contatoTutor;
  final String nomePet;
  final String especie;
  final String raca;
  final DateTime dataEntrada;
  final DateTime? dataSaida; // Pode ser nulo
  final int? diariasAteMomento;
  final int? diariasTotaisPrevistas;

  PetModel({
    this.id,
    required this.nomeTutor,
    required this.contatoTutor,
    required this.nomePet,
    required this.especie,
    required this.raca,
    required this.dataEntrada,
    this.dataSaida,
    this.diariasAteMomento,
    this.diariasTotaisPrevistas,
  });

  factory PetModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDataSaida() {
      if (json['dataSaida'] != null &&
          (json['dataSaida'] as String).isNotEmpty) {
        try {
          return DateTime.parse(json['dataSaida']);
        } catch (e) {
          if (kDebugMode) {
            print(
              'Erro ao formatar a data de saída: ${json['dataSaida']} - $e',
            );
          }
          return null;
        }
      }
      return null;
    }

    return PetModel(
      id: json['id']?.toString(),
      nomeTutor: json['nomeTutor'] ?? '',
      contatoTutor: json['contatoTutor'] ?? '',
      nomePet: json['nomePet'] ?? '',
      especie: json['especie'] ?? '',
      raca: json['raca'] ?? '',
      dataEntrada:
          DateTime.tryParse(json['dataEntrada'] ?? '') ?? DateTime.now(),
      dataSaida: parseDataSaida(),
      diariasAteMomento: json['diariasAteMomento'] != null
          ? int.tryParse(json['diariasAteMomento'].toString())
          : null,
      diariasTotaisPrevistas: json['diariasTotaisPrevistas'] != null
          ? int.tryParse(json['diariasTotaisPrevistas'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nomeTutor': nomeTutor,
      'contatoTutor': contatoTutor,
      'nomePet': nomePet,
      'especie': especie,
      'raca': raca,
      'dataEntrada': dataEntrada.toIso8601String().split('T')[0],
      if (dataSaida != null)
        'dataSaida': dataSaida!.toIso8601String().split('T')[0],
      if (diariasAteMomento != null) 'diariasAteMomento': diariasAteMomento,
      if (diariasTotaisPrevistas != null)
        'diariasTotaisPrevistas': diariasTotaisPrevistas,
    };
  }
}
