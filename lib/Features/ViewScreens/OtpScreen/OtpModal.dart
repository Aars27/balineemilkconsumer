class UserModel {
  final int id;
  final String firstName;
  final String lastName;
  final String mobileNo;
  final String address;
  final int roleId;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.mobileNo,
    required this.address,
    required this.roleId,
  });


  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      firstName: json['first_name'] ?? "",
      lastName: json['last_name'] ?? "",
      mobileNo: json['mobile_no'] ?? "",
      address: json['address'] ?? "",
      roleId: json['role_id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "first_name": firstName,
      "last_name": lastName,
      "mobile_no": mobileNo,
      "address": address,
      "role_id": roleId,
    };
  }

  // Convenience getter
  String get fullName => "$firstName $lastName".trim();
}




class OtpVerifyResponse {
  final bool flag;
  final String message;
  final String? token;
  final UserModel? user;

  OtpVerifyResponse({
    required this.flag,
    required this.message,
    this.token,
    this.user,
  });

  factory OtpVerifyResponse.fromJson(Map<String, dynamic> json) {
    return OtpVerifyResponse(
      flag: json["flag"] ?? false,
      message: json["message"] ?? "",
      token: json["token"],
      user: json["user"] != null ? UserModel.fromJson(json["user"]) : null,
    );
  }
}
