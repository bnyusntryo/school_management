// ✅ Resp model untuk wrap API response
// Response structure: {data: ..., message: "...", total: ...}
// HTTP statusCode diambil dari Dio response, bukan dari body

class Resp {
  final int? code;      // ← dari HTTP statusCode (200, 404, 500)
  final dynamic data;   // ← dari response body
  final dynamic message;
  final dynamic error;

  Resp({
    this.code,
    this.data,
    this.message,
    this.error,
  });

  // ✅ PENTING: fromJson harus menerima FULL response dari Network class
  // Bukan hanya response body, tapi juga statusCode
  factory Resp.fromJson(Map<String, dynamic> json) {
    return Resp(
      code: json['statusCode'] ?? json['code'], // ← dari wrapper Network class
      data: json['data'],                        // ← dari response body
      message: json['message'],                  // ← dari response body
      error: json['error'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'data': data,
      'message': message,
      'error': error,
    };
  }

  @override
  String toString() {
    return 'Resp(code: $code, message: $message, hasData: ${data != null})';
  }
}