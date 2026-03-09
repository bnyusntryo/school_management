class ClientModel {
  final String clientId;
  final String clientName;
  final String clientLogo;
  final String clientLoginImg;

  ClientModel({
    required this.clientId,
    required this.clientName,
    required this.clientLogo,
    required this.clientLoginImg,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      clientId: json['client_id'] ?? '',
      clientName: json['client_name'] ?? '',
      clientLogo: json['client_logo'] ?? '',
      clientLoginImg: json['client_login_img'] ?? '',
    );
  }
}