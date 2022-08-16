part of 'login_bloc.dart';

class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginSubmitted extends LoginEvent {
  const LoginSubmitted({
    required this.domainName,
    required this.username,
    required this.password,
  });

  final String domainName;
  final String username;
  final String password;

  @override
  List<Object> get props => [domainName, username, password];
}

class LoginDomainNameChanged extends LoginEvent {
  const LoginDomainNameChanged(this.domainName);

  final String domainName;

  @override
  List<Object> get props => [domainName];
}

class LoginUsernameChanged extends LoginEvent {
  const LoginUsernameChanged(this.username);

  final String username;

  @override
  List<Object> get props => [username];
}

class LoginPasswordChanged extends LoginEvent {
  const LoginPasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

class LoginPasswordVisibleChanged extends LoginEvent {
  const LoginPasswordVisibleChanged({required this.passwordVisible});

  final bool passwordVisible;

  @override
  List<Object> get props => [passwordVisible];
}
