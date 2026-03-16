// ✅ DART-1: fromJson dengan ?? fallback untuk semua field
// ✅ Model hanya data properties + parsing, tidak ada business logic

class TeacherInfoModel {
  final String userid;
  final String fullName;
  final String joinDate;
  final String gender;
  final String userPhoto;

  TeacherInfoModel({
    required this.userid,
    required this.fullName,
    required this.joinDate,
    required this.gender,
    required this.userPhoto,
  });

  // ✅ fromJson dengan fallback - DART-1 compliant
  factory TeacherInfoModel.fromJson(Map<String, dynamic> json) {
    return TeacherInfoModel(
      userid: json['userid']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? 'Unknown Teacher',
      joinDate: json['join_date']?.toString() ?? '',
      gender: json['gender']?.toString() ?? '',
      userPhoto: json['user_photo']?.toString() ?? '',
    );
  }

  // ✅ toJson untuk serialization (jika diperlukan untuk POST/PUT)
  Map<String, dynamic> toJson() {
    return {
      'userid': userid,
      'full_name': fullName,
      'join_date': joinDate,
      'gender': gender,
      'user_photo': userPhoto,
    };
  }

  // ✅ Helper method untuk avatar URL dengan fallback
  String get avatarUrl {
    if (userPhoto.isNotEmpty) {
      // ✅ Asumsi: base URL dari server untuk photo
      // Sesuaikan dengan endpoint actual dari backend kamu
      return 'https://schoolapp-api-dev.zeabur.app/uploads/$userPhoto';
    }
    // ✅ Fallback ke pravatar dengan userid sebagai seed
    return 'https://i.pravatar.cc/150?u=$userid';
  }

  // ✅ Helper untuk display name yang user-friendly
  String get displayName => fullName.isNotEmpty ? fullName : 'Unknown Teacher';

  // ✅ Helper untuk cek apakah punya foto
  bool get hasPhoto => userPhoto.isNotEmpty;

  // ✅ copyWith untuk immutability pattern (opsional, tapi good practice)
  TeacherInfoModel copyWith({
    String? userid,
    String? fullName,
    String? joinDate,
    String? gender,
    String? userPhoto,
  }) {
    return TeacherInfoModel(
      userid: userid ?? this.userid,
      fullName: fullName ?? this.fullName,
      joinDate: joinDate ?? this.joinDate,
      gender: gender ?? this.gender,
      userPhoto: userPhoto ?? this.userPhoto,
    );
  }

  @override
  String toString() {
    return 'TeacherModel(userid: $userid, fullName: $fullName, gender: $gender)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TeacherInfoModel && other.userid == userid;
  }

  @override
  int get hashCode => userid.hashCode;
}