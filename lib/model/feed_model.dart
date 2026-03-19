class FeedPostModel {
  final String feedpostId;
  final String creator;
  final String creatorStatus;
  final String createdAt;
  final String feedpostName;
  final int feedpostTotalLike;
  final int feedpostTotalComment;
  final List<String> feedpostImg;
  final String userPhoto;
  final bool isLikedLocal;

  FeedPostModel({
    required this.feedpostId,
    required this.creator,
    required this.creatorStatus,
    required this.createdAt,
    required this.feedpostName,
    required this.feedpostTotalLike,
    required this.feedpostTotalComment,
    required this.feedpostImg,
    required this.userPhoto,
    required this.isLikedLocal,
  });

  String get avatarUrl {
    if (userPhoto.isNotEmpty) return userPhoto;
    final encoded = creator.replaceAll(' ', '+');
    return 'https://ui-avatars.com/api/?name=$encoded&background=random';
  }

  FeedPostModel copyWith({int? feedpostTotalLike, bool? isLikedLocal}) {
    return FeedPostModel(
      feedpostId: feedpostId,
      creator: creator,
      creatorStatus: creatorStatus,
      createdAt: createdAt,
      feedpostName: feedpostName,
      feedpostTotalLike: feedpostTotalLike ?? this.feedpostTotalLike,
      feedpostTotalComment: feedpostTotalComment,
      feedpostImg: feedpostImg,
      userPhoto: userPhoto,
      isLikedLocal: isLikedLocal ?? this.isLikedLocal,
    );
  }

  factory FeedPostModel.fromJson(Map<String, dynamic> json) {
    return FeedPostModel(
      feedpostId: json['feedpost_id']?.toString() ?? '',
      creator: json['creator']?.toString() ?? 'Unknown',
      creatorStatus: json['creator_status']?.toString() ?? '-',
      createdAt: json['created_at']?.toString() ?? '',
      feedpostName: json['feedpost_name']?.toString() ?? '',
      feedpostTotalLike: (json['feedpost_total_like'] as num?)?.toInt() ?? 0,
      feedpostTotalComment:
          (json['feedpost_total_comment'] as num?)?.toInt() ?? 0,
      feedpostImg: (json['feedpost_img'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      userPhoto: json['user_photo']?.toString() ?? '',
      isLikedLocal: json['is_liked_local'] as bool? ?? false,
    );
  }
}

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
