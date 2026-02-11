class ApiResponse<T> {
  const ApiResponse({required this.message, required this.payload});

  final String message;
  final T payload;

  static ApiResponse<List<dynamic>> fromJsonMap(Map<String, dynamic> json) {
    return ApiResponse<List<dynamic>>(
      message: json['message'] as String? ?? '',
      payload: (json['payload'] as List<dynamic>? ?? <dynamic>[]),
    );
  }
}
