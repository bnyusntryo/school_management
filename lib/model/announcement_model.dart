class AnnouncementModel {
  final String title;
  final String description;
  final String showAnnouncement;
  final List<String> images;

  AnnouncementModel({
    required this.title,
    required this.description,
    required this.showAnnouncement,
    required this.images,
  });

  bool get shouldShow => showAnnouncement == 'Y';

  String get imageUrl => images.isNotEmpty
      ? 'https://fastly.picsum.photos/id/517/1600/900.jpg?hmac=CdnOMbQEo4LItWYoyDHPpmPs3HPyGBFBnOFiel377XI'
      : 'https://images.unsplash.com/photo-1580582932707-520aed937b7b?q=80&w=2000&auto=format&fit=crop';

  String get cleanDescription =>
      description.replaceAll(RegExp(r'<[^>]*>'), '').trim();

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      title: json['announcement_title']?.toString() ?? 'No Title',
      description: json['announcement_desc']?.toString() ??
          json['announcement_description']?.toString() ??
          '',
      showAnnouncement: json['show_announcement']?.toString() ?? 'N',
      images: (json['announcement_img'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}
