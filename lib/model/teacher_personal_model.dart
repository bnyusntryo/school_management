// ✅ Model untuk response API teacher personal
// ✅ DART-1: fromJson dengan ?? fallback untuk semua field
// Response structure dari /api/teacher/teacher-info/personal

class TeacherPersonalModel {
  final String userid;
  final String nuptk;
  final String fullName;
  final String bornPlace;
  final String bornDate;
  final String email;
  final String address;
  final String phoneNo;
  final String joinDate;
  final String activeStatus;
  final String gender;
  final String userPhoto;

  TeacherPersonalModel({
    required this.userid,
    required this.nuptk,
    required this.fullName,
    required this.bornPlace,
    required this.bornDate,
    required this.email,
    required this.address,
    required this.phoneNo,
    required this.joinDate,
    required this.activeStatus,
    required this.gender,
    required this.userPhoto,
  });

  // ✅ fromJson dengan fallback - DART-1 compliant
  factory TeacherPersonalModel.fromJson(Map<String, dynamic> json) {
    // ✅ Handle date format (kadang ISO, kadang empty string)
    String rawBornDate = json['born_date']?.toString() ?? '';
    String cleanBornDate = rawBornDate.isNotEmpty && rawBornDate.contains('T')
        ? rawBornDate.split('T')[0]
        : rawBornDate;

    String rawJoinDate = json['join_date']?.toString() ?? '';
    String cleanJoinDate = rawJoinDate.isNotEmpty && rawJoinDate.contains('T')
        ? rawJoinDate.split('T')[0]
        : rawJoinDate;

    return TeacherPersonalModel(
      userid: json['userid']?.toString() ?? '',
      nuptk: json['nuptk']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? 'Unknown Teacher',
      bornPlace: json['born_place']?.toString() ?? '',
      bornDate: cleanBornDate,
      email: json['email']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      phoneNo: json['phone_no']?.toString() ?? '',
      joinDate: cleanJoinDate,
      activeStatus: json['active_status']?.toString() ?? 'N',
      gender: json['gender']?.toString() ?? '',
      userPhoto: json['user_photo']?.toString() ?? '',
    );
  }

  // ✅ Helper untuk display values
  String get displayEmail => email.isEmpty ? 'Belum ada email' : email;

  String get displayNuptk => nuptk.isEmpty ? '-' : nuptk;

  String get displayActiveStatus => activeStatus == 'Y' ? 'Active' : 'Inactive';

  String get displayGender {
    if (gender == 'L') return 'Male';
    if (gender == 'P') return 'Female';
    return 'Select';
  }

  // ✅ Gender code untuk kirim ke backend
  String get genderCode {
    if (gender == 'L' || gender == 'Male') return 'L';
    if (gender == 'P' || gender == 'Female') return 'P';
    return '';
  }

  // ✅ Helper untuk avatar URL dengan fallback
  String get avatarUrl {
    if (userPhoto.isNotEmpty) {
      // ✅ Asumsi: base URL dari server untuk photo
      // Sesuaikan dengan endpoint actual dari backend kamu
      return 'https://schoolapp-api-dev.zeabur.app/uploads/$userPhoto';
    }
    // ✅ Fallback ke pravatar dengan userid sebagai seed
    return 'https://i.pravatar.cc/150?u=$userid';
  }

  bool get hasPhoto => userPhoto.isNotEmpty;

  // ✅ toJson untuk update data
  Map<String, dynamic> toJson() {
    return {
      'userid': userid,
      'nuptk': nuptk,
      'full_name': fullName,
      'born_place': bornPlace,
      'born_date': bornDate,
      'email': email == 'Belum ada email' ? '' : email,
      'address': address,
      'phone_no': phoneNo,
      'join_date': joinDate,
      'active_status': activeStatus,
      'gender': genderCode,
      'user_photo': userPhoto,
    };
  }

  @override
  String toString() {
    return 'TeacherPersonalModel(userid: $userid, fullName: $fullName, activeStatus: $activeStatus)';
  }
}