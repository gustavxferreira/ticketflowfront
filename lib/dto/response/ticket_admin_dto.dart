class TicketAdminDTO {
  final int id;
  final String areaName;
  final String categoryName;
  final String subcategoryName;
  final String calledSubject;
  final DateTime dateOpen;
  final DateTime? dateClosed;
  final String step;

  TicketAdminDTO({
    required this.id,
    required this.areaName,
    required this.categoryName,
    required this.subcategoryName,
    required this.calledSubject,
    required this.dateOpen,
    this.dateClosed,
    required this.step,
  });

  factory TicketAdminDTO.fromJson(Map<String, dynamic> json) {
    return TicketAdminDTO(
      id: json['id'],
      areaName: json['areaName'] ?? '',
      categoryName: json['categoryName'] ?? '',
      subcategoryName: json['subcategoryName'] ?? '',
      calledSubject: json['calledSubject'] ?? '',
      dateOpen: DateTime.parse(json['dateOpen']),
      dateClosed: json['dateClosed'] != null ? DateTime.parse(json['dateClosed']) : null,
      step: json['step'] ?? 'Em aberto',
    );
  }
}