class SignupRequest {
  final String firstName;
  final String lastName;
  final String mobileNo;
  final int roleId;
  final String address;

  SignupRequest({
    required this.firstName,
    required this.lastName,
    required this.mobileNo,
    required this.roleId,
    required this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      "first_name": firstName,
      "last_name": lastName,
      "mobile_no": mobileNo,
      "role_id": roleId,
      "address": address,
    };
  }
}

// -----------------------------
// RESPONSE MODEL
// -----------------------------
class SignupResponse {
  final bool flag;
  final String message;
  final int userId;

  SignupResponse({
    required this.flag,
    required this.message,
    required this.userId,
  });

  factory SignupResponse.fromJson(Map<String, dynamic> json) {
    return SignupResponse(
      flag: json["flag"] ?? false,
      message: json["message"] ?? "",
      userId: json["user_id"] ?? 0,
    );
  }
}

