part of 'edit_broker_bloc.dart';

class EditBrokerEvent extends Equatable {
  const EditBrokerEvent();

  @override
  List<Object?> get props => [];
}

class EditSubmitted extends EditBrokerEvent {
  const EditSubmitted({
    required this.brokerName,
    required this.urlName,
    required this.brokerAccount,
    required this.brokerPassword,
  });

  final String brokerName;
  final String urlName;
  final String? brokerAccount;
  final String? brokerPassword;

  @override
  List<Object?> get props =>
      [brokerName, urlName, brokerAccount, brokerPassword];
}

class EditBrokerNameChanged extends EditBrokerEvent {
  const EditBrokerNameChanged(this.brokerName);

  final String brokerName;

  @override
  List<Object> get props => [brokerName];
}

class EditUrlNameChanged extends EditBrokerEvent {
  const EditUrlNameChanged(this.urlName);

  final String urlName;

  @override
  List<Object> get props => [urlName];
}

class EditBrokerAccountChanged extends EditBrokerEvent {
  const EditBrokerAccountChanged(this.brokerAccount);

  final String brokerAccount;

  @override
  List<Object> get props => [brokerAccount];
}

class EditBrokerPasswordChanged extends EditBrokerEvent {
  const EditBrokerPasswordChanged(this.brokerPassword);

  final String brokerPassword;

  @override
  List<Object> get props => [brokerPassword];
}
