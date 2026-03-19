class CommentModel {
  final String commenter;
  final String commentText;
  final String createdAt;
  final String userPhoto;

  CommentModel({
    required this.commenter,
    required this.commentText,
    required this.createdAt,
    required this.userPhoto,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      commenter: json['commenter']?.toString() ?? 'Unknown',
      commentText: json['comment_name']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
      userPhoto: json['user_photo']?.toString() ?? '',
    );
  }

  String get avatarUrl {
    if (userPhoto.isNotEmpty) return userPhoto;
    final encoded = commenter.replaceAll(' ', '+');
    return 'https://ui-avatars.com/api/?name=$encoded&background=random';
  }
}
