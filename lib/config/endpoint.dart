class Endpoint {
  static const String authLoginUrl = '/auth';
  static const String refreshTokenUrl = '/api/refresh-token';
  static const String clientUrl = '/clients';
  static const String teacherInfoListUrl = '/teacher/teacher-info/list';
  static const String teacherInfoPersonalUrl = '/teacher/teacher-info/personal';
  static const String classListUrl = '/schoolactivity/classactivity/class-list';
  static const String classDetailUrl = '/schoolactivity/classactivity/class-detail';
  static const String subjectListUrl = '/schoolactivity/classactivity/subject-list';
  static const String subjectDetailUrl = '/schoolactivity/classactivity/subject-detail';
  static const String activityListUrl = '/schoolactivity/classactivity/activity-list';
  static const String activityDetailUrl = '/schoolactivity/classactivity/detail';
  static const String studentListUrl = '/schoolactivity/classactivity/student/list';
  static const String reportGetClassUrl = '/schoolactivity/reports/getclass';
  static const String reportSubmitUrl = '/schoolactivity/reports/classactivity';

  static const String feedCommentListUrl = '/api/home/feeds/comment/list';

  static const String attendanceListUrl = '/api/attendance/myattendance-list';
  static const String attendanceLocationUrl = '/api/attendance/get-location';
  static const String attendanceLimitUrl = '/api/attendance/today-attendance-limit';
}