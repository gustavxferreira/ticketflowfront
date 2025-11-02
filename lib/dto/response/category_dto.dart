import 'package:ticketflowfront/dto/response/sub_category_dto.dart';

class CategoryDTO {
  final int id;
  final String name;
  final String description;
  final List<SubcategoryDTO> subcategories;

  CategoryDTO({
    required this.id,
    required this.name,
    required this.description,
    required this.subcategories,
  });

  factory CategoryDTO.fromJson(Map<String, dynamic> json) {
    var subs = json['subcategories'] as List<dynamic>? ?? [];
    return CategoryDTO(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      subcategories:
          subs.map((s) => SubcategoryDTO.fromJson(s)).toList(),
    );
  }
}