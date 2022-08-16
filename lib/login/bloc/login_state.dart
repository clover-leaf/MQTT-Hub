part of 'login_bloc.dart';

class LoginState extends Equatable {
  const LoginState({
    this.domainName = const DomainName.pure(),
    this.username = const Username.pure(),
    this.password = const Password.pure(),
    this.status = FormzStatus.pure,
    this.valid = false,
    this.passwordVisible = false,
    this.token,
    this.error,
  });

  final DomainName domainName;
  final Username username;
  final Password password;
  final FormzStatus status;
  final String? token;
  final bool valid;
  final bool passwordVisible;
  final String? error;

  @override
  List<Object?> get props => [
        domainName,
        username,
        password,
        status,
        valid,
        passwordVisible,
        token,
        error
      ];

  LoginState copyWith({
    DomainName? domainName,
    Username? username,
    Password? password,
    FormzStatus? status,
    bool? valid,
    bool? passwordVisible,
    String? token,
    String? error,
  }) {
    return LoginState(
      domainName: domainName ?? this.domainName,
      username: username ?? this.username,
      password: password ?? this.password,
      status: status ?? this.status,
      valid: valid ?? this.valid,
      passwordVisible: passwordVisible ?? this.passwordVisible,
      token: token ?? this.token,
      error: error ?? this.error,
    );
  }
}
