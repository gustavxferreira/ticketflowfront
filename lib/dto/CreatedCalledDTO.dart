import 'dart:convert';

enum Priority { Low, Medium, High }

class CalledCreateDTO {
  final String userEmail;
  final String subject;
  final String description;
  final int areaId;
  final int categoryId;
  final int subCategoryId;
  final Priority priority;
  final String? evidencePath;

  CalledCreateDTO({
    required this.userEmail,
    required this.subject,
    required this.description,
    required this.areaId,
    required this.categoryId,
    required this.subCategoryId,
    this.priority = Priority.Low,
    this.evidencePath,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_email': userEmail,
      'subject': subject,
      'description': description,
      'area_id': areaId,
      'category_id': categoryId,
      'sub_category_id': subCategoryId,   
      'priority': priority.name,
      'evidence_path': evidencePath,
    };
  }

  String toJsonString() => jsonEncode(toJson());
}
