class Chamado {
  final int id;
  final String subject;
  final String description;

  Chamado({required this.id, required this.subject, required this.description});

  factory Chamado.fromJson(Map<String, dynamic> json) {
    return Chamado(
      id: json['id'],
      subject: json['subject'],
      description: json['description'],
    );
  }
}
