class Chamado {

  final String id;
  final String subject;
  final String description;
  final String status;

  Chamado({
    required this.id,
    required this.subject,
    required this.description,
    required this.status,
  });

  factory Chamado.fromJson(Map<String, dynamic> json) {
    return Chamado(
      id: json['id'],
      subject: json['subject'],
      description: json['description'],
      status: 'vazio'
    );
  }
}
