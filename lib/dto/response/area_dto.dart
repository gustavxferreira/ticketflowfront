import 'package:ticketflowfront/dto/response/category_dto.dart';

class AreaDTO {
  final int id;
  final String name;
  final List<CategoryDTO> categories;

  AreaDTO({required this.id, required this.name, required this.categories});

  factory AreaDTO.fromJson(Map<String, dynamic> json) {
    var cats = json['categories'] as List<dynamic>? ?? [];
    return AreaDTO(
      id: json['id'],
      name: json['name'],
      categories: cats.map((c) => CategoryDTO.fromJson(c)).toList(),
    );
  }
}