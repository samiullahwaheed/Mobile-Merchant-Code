class CheckoutResponse {
  final bool success;
  final String message;
  final List<ErrorMessage>? errorMessages;

  CheckoutResponse({
    required this.success,
    required this.message,
    this.errorMessages,
  });

  factory CheckoutResponse.fromJson(Map<String, dynamic> json) {
    return CheckoutResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      errorMessages: json['errorMessages'] != null
          ? (json['errorMessages'] as List)
                .map((e) => ErrorMessage.fromJson(e))
                .toList()
          : null,
    );
  }
}

class ErrorMessage {
  final String path;
  final String message;

  ErrorMessage({required this.path, required this.message});

  factory ErrorMessage.fromJson(Map<String, dynamic> json) {
    return ErrorMessage(
      path: json['path'] ?? '',
      message: json['message'] ?? '',
    );
  }
}
