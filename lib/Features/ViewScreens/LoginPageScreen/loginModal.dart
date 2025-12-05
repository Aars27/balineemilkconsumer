class LoginResponse {
  final bool flag;
  final String message;
  final int userId;

  LoginResponse({
    required this.flag,
    required this.message,
    required this.userId,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      flag: json['flag'] ?? false,
      message: json['message'] ?? '',
      userId: json['data'] ?? 0,
    );
  }
}
