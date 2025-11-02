class SubcategoryDTO {
  final int id;
  final String name;

  SubcategoryDTO({required this.id, required this.name});

  factory SubcategoryDTO.fromJson(Map<String, dynamic> json) {
    return SubcategoryDTO(
      id: json['id'],
      name: json['name'],
    );
  }
}