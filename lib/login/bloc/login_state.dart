part of 'login_bloc.dart';

enum LoginStatus {
  normal,
  processing,
  success,
  failure,
}

extension LoginStatusX on LoginStatus {
  bool isProcessing() => this == LoginStatus.processing;
  bool isSuccess() => this == LoginStatus.success;
  bool isFailure() => this == LoginStatus.failure;
}

class LoginState extends Equatable {
  const LoginState({
    this.status = LoginStatus.normal,
    this.domainName = '',
    this.username = '',
    this.password = '',
    this.token,
    this.error,
    this.isAdmin,
  });

  final LoginStatus status;
  final String domainName;
  final String username;
  final String password;
  final String? token;
  final String? error;
  final bool? isAdmin;


  @override
  List<Object?> get props =>
      [domainName, username, password, status, token, error, isAdmin];

  LoginState copyWith({
    String? domainName,
    String? username,
    String? password,
    LoginStatus? status,
    String? token,
    bool? isAdmin,
    String? Function()? error,
  }) {
    return LoginState(
      domainName: domainName ?? this.domainName,
      username: username ?? this.username,
      password: password ?? this.password,
      status: status ?? this.status,
      token: token ?? this.token,
      isAdmin: isAdmin ?? this.isAdmin,
      error: error != null ? error() : this.error,
    );
  }
}
