part of 'edit_broker_bloc.dart';

enum EditBrokerStatus {
  normal,
  processing,
  success,
  failure,
}

extension EditBrokerStatusX on EditBrokerStatus {
  bool isProcessing() => this == EditBrokerStatus.processing;
  bool isSuccess() => this == EditBrokerStatus.success;
  bool isFailure() => this == EditBrokerStatus.failure;
}

class EditBrokerState extends Equatable {
  const EditBrokerState({
    this.status = EditBrokerStatus.normal,
    required this.parentProject,
    required this.isEdit,
    required this.isAdmin,
    this.name = '',
    this.url = '',
    this.port = '',
    this.account = '',
    this.password = '',
    this.initialBroker,
    this.error,
  });

  // immutate
  final Project parentProject;

  // input
  final String name;
  final String url;
  final String port;
  final String account;
  final String password;

  // initial
  final Broker? initialBroker;

  // status
  final EditBrokerStatus status;
  final bool isEdit;
  final bool isAdmin;
  final String? error;

  @override
  List<Object?> get props => [
        parentProject,
        name,
        port,
        url,
        account,
        password,
        initialBroker,
        status,
        isEdit,
        isAdmin,
        error
      ];

  EditBrokerState copyWith({
    Project? parentProject,
    String? name,
    String? url,
    String? port,
    String? account,
    String? password,
    EditBrokerStatus? status,
    Broker? initialBroker,
    bool? isEdit,
    bool? isAdmin,
    String? Function()? error,
  }) {
    return EditBrokerState(
      isEdit: isEdit ?? this.isEdit,
      isAdmin: isAdmin ?? this.isAdmin,
      parentProject: parentProject ?? this.parentProject,
      name: name ?? this.name,
      url: url ?? this.url,
      port: port ?? this.port,
      account: account ?? this.account,
      password: password ?? this.password,
      status: status ?? this.status,
      initialBroker: initialBroker ?? this.initialBroker,
      error: error != null ? error() : this.error,
    );
  }
}
