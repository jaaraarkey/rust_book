import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final User? user;
  final String? errorMessage;
  final String? successMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
    this.successMessage,
  });

  @override
  List<Object?> get props => [status, user, errorMessage, successMessage];

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? errorMessage,
    String? successMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }

  // Helper getters
  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isLoading => status == AuthStatus.loading;
  bool get hasError => status == AuthStatus.error;
  bool get isInitial => status == AuthStatus.initial;
  bool get isUnauthenticated => status == AuthStatus.unauthenticated;

  // Named constructors for common states
  factory AuthState.initial() {
    return const AuthState(status: AuthStatus.initial);
  }

  factory AuthState.loading() {
    return const AuthState(status: AuthStatus.loading);
  }

  factory AuthState.authenticated(User user, {String? successMessage}) {
    return AuthState(
      status: AuthStatus.authenticated,
      user: user,
      successMessage: successMessage,
    );
  }

  factory AuthState.unauthenticated({String? message}) {
    return AuthState(
      status: AuthStatus.unauthenticated,
      successMessage: message,
    );
  }

  factory AuthState.error(String errorMessage) {
    return AuthState(
      status: AuthStatus.error,
      errorMessage: errorMessage,
    );
  }
}
