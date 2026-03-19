class AttendanceRecord {
  final String name;
  final String date;
  final String schIn;
  final String schOut;
  final String actIn;
  final String actOut;
  final String status;

  AttendanceRecord({
    required this.name,
    required this.date,
    required this.schIn,
    required this.schOut,
    required this.actIn,
    required this.actOut,
    required this.status,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    final schIn = json['sch_attend_in']?.toString() ?? '00:00:00';
    final rawActIn = json['act_attend_in']?.toString() ?? '';
    final statusServer = json['attend_status']?.toString() ?? '';

    String finalStatus;
    if (statusServer.isNotEmpty) {
      finalStatus = statusServer;
    } else if (rawActIn.isNotEmpty && rawActIn != 'null' && rawActIn != '-') {
      finalStatus = rawActIn.compareTo(schIn) > 0 ? 'Late' : 'On Time';
    } else {
      finalStatus = 'On Time';
    }

    return AttendanceRecord(
      name: json['full_name']?.toString() ?? 'Unknown',
      date: json['attendance_date']?.toString() ?? '-',
      schIn: schIn,
      schOut: json['sch_attend_out']?.toString() ?? '--:--:--',
      actIn: rawActIn.isEmpty || rawActIn == 'null' ? '--:--:--' : rawActIn,
      actOut: json['act_attend_out']?.toString() ?? '--:--:--',
      status: finalStatus,
    );
  }

  bool get isLate => status == 'Late';
  bool get isAbsent => status != 'On Time' && status != 'Late';
}

class AttendanceLocation {
  final String locationName;
  final String latitude;
  final String longitude;

  AttendanceLocation({
    required this.locationName,
    required this.latitude,
    required this.longitude,
  });

  factory AttendanceLocation.fromJson(Map<String, dynamic> json) {
    return AttendanceLocation(
      locationName: json['location_name']?.toString() ?? 'Unknown Location',
      latitude: json['latitude']?.toString() ?? '',
      longitude: json['longitude']?.toString() ?? '',
    );
  }
}
