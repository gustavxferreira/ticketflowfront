class MyTicketDTO {
  final String areaName;
  final String categoryName;
  final String subcategoryName;
  final String calledSubject;
  final String dateOpen;
  final String? dateClosed; 
  final String step;

  MyTicketDTO({
    required this.areaName,
    required this.categoryName,
    required this.subcategoryName,
    required this.calledSubject,
    required this.dateOpen,
    this.dateClosed,
    required this.step,
  });

  factory MyTicketDTO.fromJson(Map<String, dynamic> json) {
    return MyTicketDTO(
    
      areaName: json['areaName'] ?? '',
      categoryName: json['categoryName'] ?? '',
      subcategoryName: json['subcategoryName'] ?? '',
      calledSubject: json['calledSubject'] ?? 'Sem assunto',
      dateOpen: json['dateOpen'] ?? '',
      dateClosed: json['dateClosed'], 
      step: json['step'] ?? '',
    );
  }
  
  DateTime get parsedDateOpen {
    try {
      return DateTime.parse(dateOpen);
    } catch (e) {
      return DateTime.now();
    }
  }
}