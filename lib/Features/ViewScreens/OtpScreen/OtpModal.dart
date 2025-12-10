class UserModel {
  final int id;
  final String firstName;
  final String lastName;
  final String mobileNo;
  final String? email;
  final int roleId;
  final String? userType;
  final String? address;
  final int? isActive;
  final String? customerId;
  final String? fcmToken;
  final String? apiToken; // IMPORTANT

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.mobileNo,
    this.email,
    required this.roleId,
    this.userType,
    this.address,
    this.isActive,
    this.customerId,
    this.fcmToken,
    this.apiToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      firstName: json['first_name'] ?? "",
      lastName: json['last_name'] ?? "",
      mobileNo: json['mobile_no'] ?? "",
      email: json['email'],
      roleId: json['role_id'] ?? 0,
      userType: json['user_type'],
      address: json['address'],
      isActive: json['is_active'],
      customerId: json['customer_id'],
      fcmToken: json['fcm_token'],
      apiToken: json['api_token'], // backend sends token here
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "first_name": firstName,
      "last_name": lastName,
      "mobile_no": mobileNo,
      "email": email,
      "role_id": roleId,
      "user_type": userType,
      "address": address,
      "is_active": isActive,
      "customer_id": customerId,
      "fcm_token": fcmToken,
      "api_token": apiToken,
    };
  }

  String get fullName => "$firstName $lastName".trim();
}



class OtpVerifyResponse {
  final bool flag;
  final String message;
  final UserModel? user;

  OtpVerifyResponse({
    required this.flag,
    required this.message,
    this.user,
  });

  factory OtpVerifyResponse.fromJson(Map<String, dynamic> json) {
    return OtpVerifyResponse(
      flag: json["flag"] ?? false,
      message: json["message"] ?? "",
      user: json["user"] != null ? UserModel.fromJson(json["user"]) : null,
    );
  }

  // Use this to get actual token
  String? get token => user?.apiToken;
}
