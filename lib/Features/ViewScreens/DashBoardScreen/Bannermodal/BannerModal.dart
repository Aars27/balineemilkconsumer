class BannerModel {
  final int id;
  final String image;
  final int isActive;

  BannerModel({
    required this.id,
    required this.image,
    required this.isActive,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'] ?? 0,
      image: json['image'] ?? '',
      isActive: json['is_active'] ?? 0,
    );
  }
}
