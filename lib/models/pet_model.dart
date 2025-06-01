import 'dart:convert';

import 'package:flutter/foundation.dart';

class PetModel {
  final String? id; //Identificador de cada pet pra usar Put E delete
  final String nomeTutor;
  final String contatoTutor;
  final String nomePet;
  final String especie;
  final String raca;
  final DateTime dataEntrada;
  final DateTime? dataSaida; //Que pode ser nulo
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
      if (json['dataSaida'] != null && json['dataSaida'].isNotEmpty) {
        try {
          return DateTime.parse(json['dataSaida']);
        } catch (e) {
          print('Erro ao formatar a data de saída: ${json['dataSaida']} - $e');
          return null;
        }
      }
      return null;
    }

    return PetModel(
      id: json['id'] ?? json['id'],
      nomeTutor: json['nomeTutor'] ?? '',
      contatoTutor: json['contatoTutor'] ?? '',
      nomePet: json['nomePet'] ?? '',
      especie: json['especie'] ?? '',
      raca: json['raca'] ?? '',
      dataEntrada:
          DateTime.tryParse(json['dataEntrada'] ?? '') ?? DateTime.now(),
      dataSaida: parseDataSaida(),
      diariasAteMomento: json['diariasAteMomento'],
      diariasTotaisPrevistas: json['diariasTotaisPrevistas'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'nomeTutor': nomeTutor,
      'contatoTutor': contatoTutor,
      'nomePet': nomePet,
      'especie': especie,
      'raca': raca,
      'dataEntrada': dataEntrada.toIso8601String().split('T')[0],
      if (dataSaida != null)
        'dataSaida': dataSaida!.toIso8601String().split('T')[0],
    };
  }
}
