class Endpoint {
  static const String authLoginUrl = '/auth';
  static const String refreshTokenUrl = '/refresh-token';
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

  static const String announcementUrl = '/home/announcement';
  static const String todayClassUrl = '/home/mytodayclass';
  static const String feedListUrl = '/home/feeds/list';
  static const String feedCommentListUrl = '/home/feeds/comment/list';

  static const String attendanceListUrl = '/attendance/myattendance-list';
  static const String attendanceLocationUrl = '/attendance/get-location';
  static const String attendanceLimitUrl = '/attendance/today-attendance-limit';

  static const String staffInfoListUrl = '/staff/staff-info/list';
  static const String staffInfoDetailUrl = '/staff/staff-info/detail';
}