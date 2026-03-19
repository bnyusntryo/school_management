class TodayClassModel {
  final String subjectName;
  final String teacherName;
  final String className;
  final String timeStart;
  final String timeEnd;
  final bool isOngoing;

  TodayClassModel({
    required this.subjectName,
    required this.teacherName,
    required this.className,
    required this.timeStart,
    required this.timeEnd,
    required this.isOngoing,
  });

  String get timeRange => '$timeStart - $timeEnd';

  factory TodayClassModel.fromJson(
    Map<String, dynamic> json, {
    bool isOngoing = false,
  }) {
    return TodayClassModel(
      subjectName: json['subjectclass_name']?.toString() ?? 'Unknown Subject',
      teacherName: json['teacher_name']?.toString() ?? '-',
      className: json['class_name']?.toString() ?? '-',
      timeStart: json['schedule_time_start']?.toString() ?? '',
      timeEnd: json['schedule_time_end']?.toString() ?? '',
      isOngoing: isOngoing,
    );
  }
}
