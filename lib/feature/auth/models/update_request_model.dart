class UpdateRequest {
  final String email;
  final String? avatarUrl;

  UpdateRequest({required this.email, this.avatarUrl});

  Map<String, dynamic> toJson() => {
    'email': email,
    'avatarUrl': avatarUrl,
  };
}