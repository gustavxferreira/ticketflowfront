class MeDTO {
  final String message;
  final String userId;
  final String email;
  final String role;

  MeDTO({
    required this.message,
    required this.userId,
    required this.email,
    required this.role,
  });

  factory MeDTO.fromJson(Map<String, dynamic> json) {
    return MeDTO(
      message: json['message'],
      userId: json['userId'],
      email: json['email'],
      role: json['role'],
    );
  }
}
