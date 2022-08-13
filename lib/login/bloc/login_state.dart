part of 'login_bloc.dart';

class LoginState extends Equatable {
  const LoginState({
    this.domainName = const DomainName.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.status = FormzStatus.pure,
    this.valid = false,
    this.passwordVisible = false,
    this.error,
  });

  final DomainName domainName;
  final Email email;
  final Password password;
  final FormzStatus status;
  final bool valid;
  final bool passwordVisible;
  final String? error;

  @override
  List<Object?> get props =>
      [domainName, email, password, status, valid, passwordVisible, error];

  LoginState copyWith({
    DomainName? domainName,
    Email? email,
    Password? password,
    FormzStatus? status,
    bool? valid,
    bool? passwordVisible,
    String? error,
  }) {
    return LoginState(
      domainName: domainName ?? this.domainName,
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      valid: valid ?? this.valid,
      passwordVisible: passwordVisible ?? this.passwordVisible,
      error: error ?? this.error,
    );
  }
}
