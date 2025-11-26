class TicketDetailDTO {
  final String areaName;
  final String categoryName;
  final String subcategoryName;
  final String? suggestionAI;
  final String calledSubject;
  final String calledDescription;
  final DateTime dateOpen;
  final DateTime? dateClosed;
  final String? assignedTo;
  final String? reasonForClosing;
  final String step;

  TicketDetailDTO({
    required this.areaName,
    required this.categoryName,
    required this.subcategoryName,
    this.suggestionAI,
    required this.calledSubject,
    required this.calledDescription,
    required this.dateOpen,
    this.dateClosed,
    this.assignedTo,
    this.reasonForClosing,
    required this.step,
  });

  factory TicketDetailDTO.fromJson(Map<String, dynamic> json) {
    return TicketDetailDTO(
      areaName: json['areaName'],
      categoryName: json['categoryName'],
      subcategoryName: json['subcategoryName'],
      suggestionAI: json['suggestionAI'] ,
      calledSubject: json['calledSubject'],
      calledDescription: json['calledDescription'],
      dateOpen: DateTime.parse(json['dateOpen']),
      dateClosed: json['dateClosed'] != null
          ? DateTime.parse(json['dateClosed'])
          : null,
      assignedTo: json['assignedTo'],
      reasonForClosing: json['reasonForClosing'],
      step: json['step'],
    );
  }
}