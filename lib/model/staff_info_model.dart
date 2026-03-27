class StaffInfoModel {
  final String userid;
  final String fullName;
  final String posName;
  final String joinDate;
  final String gender;
  final String phoneNo;
  final String email;
  final String userPhoto;

  StaffInfoModel({
    required this.userid,
    required this.fullName,
    required this.posName,
    required this.joinDate,
    required this.gender,
    required this.phoneNo,
    required this.email,
    required this.userPhoto,
  });

  factory StaffInfoModel.fromJson(Map<String, dynamic> json) {
    return StaffInfoModel(
      userid: json['userid']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? 'Unknown Staff',
      posName: json['pos_name']?.toString() ?? '-',
      joinDate: json['join_date']?.toString() ?? '',
      gender: json['gender']?.toString() ?? '-',
      phoneNo: json['phone_no']?.toString() ?? '-',
      email: json['email']?.toString() ?? '-',
      userPhoto: json['user_photo']?.toString() ?? '',
    );
  }
}