class AppException implements Exception {
  final String message;
  final String? prefix;

  AppException(this.message, [this.prefix]);

  @override
  String toString() {
    return '${prefix ?? "Error"}: $message';
  }
}

class UserException extends AppException {
  UserException(String message) : super(message, "Error");
}

class SystemException extends AppException {
  final dynamic originalError;
  
  SystemException(String message, [this.originalError]) 
      : super(message, "System Error");
      
  @override
  String toString() {
    if (originalError != null) {
      return '${super.toString()} ($originalError)';
    }
    return super.toString();
  }
}
