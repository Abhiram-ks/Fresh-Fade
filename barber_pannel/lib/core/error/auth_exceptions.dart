/// Base exception class for authentication errors
class AuthException implements Exception {
  final String message;
  final String code;

  AuthException(this.message, {this.code = 'unknown'});

  @override
  String toString() => message;
}

/// Specific exception classes
class EmailAlreadyExistsException extends AuthException {
  EmailAlreadyExistsException()
      : super(
          'This email is already registered. Please use a different email or try logging in.',
          code: 'email-already-exists',
        );
}

class WeakPasswordException extends AuthException {
  WeakPasswordException()
      : super(
          'Password is too weak. Please use at least 6 characters.',
          code: 'weak-password',
        );
}

class InvalidEmailException extends AuthException {
  InvalidEmailException()
      : super(
          'Invalid email address. Please enter a valid email.',
          code: 'invalid-email',
        );
}

class NetworkException extends AuthException {
  NetworkException()
      : super(
          'Network error. Please check your internet connection and try again.',
          code: 'network-error',
        );
}

class UserCreationFailedException extends AuthException {
  UserCreationFailedException()
      : super(
          'Failed to create user account. Please try again.',
          code: 'user-creation-failed',
        );
}

class DatabaseException extends AuthException {
  DatabaseException([String? customMessage])
      : super(
          customMessage ?? 'Database error occurred. Please try again later.',
          code: 'database-error',
        );
}

class UnknownException extends AuthException {
  UnknownException([String? customMessage])
      : super(
          customMessage ?? 'An unexpected error occurred. Please try again.',
          code: 'unknown-error',
        );
}

// Login specific exceptions
class InvalidCredentialsException extends AuthException {
  InvalidCredentialsException()
      : super(
          'Invalid email or password. Please check your credentials and try again.',
          code: 'invalid-credentials',
        );
}

class UserNotFoundException extends AuthException {
  UserNotFoundException()
      : super(
          'No account found with this email. Please register first.',
          code: 'user-not-found',
        );
}

class EmailNotVerifiedException extends AuthException {
  EmailNotVerifiedException()
      : super(
          'Email not verified. Please verify your email to continue.',
          code: 'email-not-verified',
        );
}

class UserDisabledException extends AuthException {
  UserDisabledException()
      : super(
          'Your account has been disabled. Please contact support.',
          code: 'user-disabled',
        );
}

class AccountBlockedException extends AuthException {
  AccountBlockedException()
      : super(
          'Your account has been blocked. Please contact support.',
          code: 'account-blocked',
        );
}
