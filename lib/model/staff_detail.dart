class StaffDetailModel {
  final String userid;
  final String fullName;
  final String posName;
  final String birthDate;
  final String birthPlace;
  final String joinDate;
  final String gender;
  final String phoneNo;
  final String address;
  final String email;
  final String userPhoto;

  StaffDetailModel({
    required this.userid,
    required this.fullName,
    required this.posName,
    required this.birthDate,
    required this.birthPlace,
    required this.joinDate,
    required this.gender,
    required this.phoneNo,
    required this.address,
    required this.email,
    required this.userPhoto,
  });

  factory StaffDetailModel.fromJson(Map<String, dynamic> json) {
    return StaffDetailModel(
      userid: json['userid']?.toString() ?? '',
      fullName: json['full_name']?.toString() ?? '',
      posName: json['pos_name']?.toString() ?? '-',
      birthDate: json['birth_date']?.toString() ?? '',
      birthPlace: json['birth_place']?.toString() ?? '',
      joinDate: json['join_date']?.toString() ?? '',
      gender: json['gender']?.toString() ?? '-',
      phoneNo: json['phone_no']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      userPhoto: json['user_photo']?.toString() ?? '',
    );
  }
}