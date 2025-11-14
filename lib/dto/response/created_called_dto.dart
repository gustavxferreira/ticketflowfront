import 'dart:convert';
import 'package:ticketflowfront/enums/priority_enum.dart';

class CreatedCalledDTO {
  final int id;
  // final String userEmail;
  // final String subject;
  // final String description;
  // final int areaId;
  // final int categoryId;
  // final int subCategoryId;
  // final Priority priority;
  // final String? evidencePath;
  // final DateTime createdAt;

  CreatedCalledDTO({
    required this.id,
    // required this.userEmail,
    // required this.subject,
    // required this.description,
    // required this.areaId,
    // required this.categoryId,
    // required this.subCategoryId,
    // required this.priority,
    // this.evidencePath,
    // required this.createdAt,
  });

  factory CreatedCalledDTO.fromJson(Map<String, dynamic> json) {
    return CreatedCalledDTO(
      id: json['id'],
      // userEmail: json['user_email'],
      // subject: json['subject'],
      // description: json['description'],
      // areaId: json['area_id'],
      // categoryId: json['category_id'],
      // subCategoryId: json['sub_category_id'],
      // priority: Priority.values.firstWhere(
      //   (p) =>
      //       p.name.toLowerCase() == (json['priority'] as String).toLowerCase(),
      //   orElse: () => Priority.low,
      // ),
      // evidencePath: json['evidence_path'],
      // createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      // 'user_email': userEmail,
      // 'subject': subject,
      // 'description': description,
      // 'area_id': areaId,
      // 'category_id': categoryId,
      // 'sub_category_id': subCategoryId,
      // 'priority': priority.name,
      // 'evidence_path': evidencePath,
      // 'created_at': createdAt.toIso8601String(),
    };
  }

  String toJsonString() => jsonEncode(toJson());
}
