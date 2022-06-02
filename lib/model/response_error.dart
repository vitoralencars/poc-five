class ResponseError {
  final int statusCode;
  final String errorMessage;

  ResponseError({
    required this.statusCode,
    required this.errorMessage
  });

  factory ResponseError.fromJson(Map<String, dynamic> json) {
    return ResponseError(
        statusCode: json['statusCode'],
        errorMessage: json['errorMessage']
    );
  }
}