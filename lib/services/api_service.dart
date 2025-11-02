import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ticketflowfront/dto/CreatedCalledDTO.dart';
import 'package:ticketflowfront/dto/response/area_dto.dart';
import 'package:ticketflowfront/models/chamado.dart';

class ApiService {
  static const baseUrl = 'http://localhost:5233/api';

  static Future<List<Chamado>> fetchChamados() async {
    // Simula delay de rede
    await Future.delayed(Duration(seconds: 1));

    return [
      Chamado(
        id: 1,
        subject: 'Chamado 1',
        description: 'Descrição do chamado 1',
      ),
      Chamado(
        id: 2,
        subject: 'Chamado 2',
        description: 'Descrição do chamado 2',
      ),
      Chamado(
        id: 3,
        subject: 'Chamado 3',
        description: 'Descrição do chamado 3',
      ),
    ];
  }

  static Future<void> createCalled(
    BuildContext context,
    CalledCreateDTO dto,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/chamados'),
      headers: {'Content-Type': 'application/json'},
      body: dto.toJsonString(),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Chamado criado com sucesso!'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao criar chamado: ${response.body}'),
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ),
      );
      throw Exception('Erro ao criar chamado: ${response.body}');
    }
  }

  static Future<List<AreaDTO>> fetchCategories() async {
    final response = await http.get(
      Uri.parse('$baseUrl/categorias'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => AreaDTO.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao carregar áreas: ${response.body}');
    }
  }
}

//   static Future<List<Chamado>> fetchChamados() async {
//     final response = await http.get(Uri.parse('$baseUrl/chamado'));
//     if (response.statusCode == 200) {
//       final List jsonData = jsonDecode(response.body);
//       return jsonData.map((e) => Chamado.fromJson(e)).toList();
//     } else {
//       throw Exception('Erro ao carregar chamados');
//     }
//   }

//   static Future<void> createChamado(String subject, String description) async {
//     final response = await http.post(
//       Uri.parse('$baseUrl/chamado'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'subject': subject, 'description': description}),
//     );

//     if (response.statusCode != 200) {
//       throw Exception('Erro ao criar chamado');
//     }
//   }
// }

// class ApiService {
//   static Future<List<Chamado>> fetchChamados() async {
//     // Simula delay de rede
//     await Future.delayed(Duration(seconds: 1));

//     return [
//       Chamado(id: 1, subject: 'Chamado 1', description: 'Descrição do chamado 1'),
//       Chamado(id: 2, subject: 'Chamado 2', description: 'Descrição do chamado 2'),
//       Chamado(id: 3, subject: 'Chamado 3', description: 'Descrição do chamado 3'),
//     ];
//   }

//   static Future<void> createChamado(String subject, String description) async {
//     // Simula delay de rede
//     await Future.delayed(Duration(milliseconds: 500));
//     print('Chamado criado: $subject - $description');
//   }
// }
