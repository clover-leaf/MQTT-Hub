part of 'edit_broker_bloc.dart';

class EditBrokerState extends Equatable {
  const EditBrokerState({
    required this.project,
    this.brokerName = const BrokerName.pure(),
    this.urlName = const UrlName.pure(),
    this.brokerAccount = const BrokerAccount.pure(),
    this.brokerPassword = const BrokerPassword.pure(),
    this.status = FormzStatus.pure,
    this.valid = false,
    this.initBroker,
    this.error,
  });

  final Project project;
  final BrokerName brokerName;
  final UrlName urlName;
  final BrokerAccount brokerAccount;
  final BrokerPassword brokerPassword;
  final FormzStatus status;
  final bool valid;
  final Broker? initBroker;
  final String? error;

  @override
  List<Object?> get props => [
        project,
        brokerName,
        urlName,
        brokerAccount,
        brokerPassword,
        initBroker,
        status,
        valid,
        error
      ];

  EditBrokerState copyWith({
    Project? project,
    BrokerName? brokerName,
    UrlName? urlName,
    BrokerAccount? brokerAccount,
    BrokerPassword? brokerPassword,
    FormzStatus? status,
    bool? valid,
    Broker? initBroker,
    String? error,
  }) {
    return EditBrokerState(
      project: project ?? this.project,
      brokerName: brokerName ?? this.brokerName,
      urlName: urlName ?? this.urlName,
      brokerAccount: brokerAccount ?? this.brokerAccount,
      brokerPassword: brokerPassword ?? this.brokerPassword,
      status: status ?? this.status,
      valid: valid ?? this.valid,
      initBroker: initBroker ?? this.initBroker,
      error: error ?? this.error,
    );
  }
}
