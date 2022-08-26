part of 'edit_broker_bloc.dart';

class EditBrokerEvent extends Equatable {
  const EditBrokerEvent();

  @override
  List<Object?> get props => [];
}

class Submitted extends EditBrokerEvent {
  const Submitted();
}

class NameChanged extends EditBrokerEvent {
  const NameChanged(this.name);

  final String name;

  @override
  List<Object> get props => [name];
}

class UrlChanged extends EditBrokerEvent {
  const UrlChanged(this.url);

  final String url;

  @override
  List<Object> get props => [url];
}

class PortChanged extends EditBrokerEvent {
  const PortChanged(this.port);

  final String port;

  @override
  List<Object> get props => [port];
}

class AccountChanged extends EditBrokerEvent {
  const AccountChanged(this.account);

  final String account;

  @override
  List<Object> get props => [account];
}

class PasswordChanged extends EditBrokerEvent {
  const PasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}
