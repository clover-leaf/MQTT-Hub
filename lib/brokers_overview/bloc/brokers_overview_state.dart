part of 'brokers_overview_bloc.dart';

enum BrokersOverviewStatus {
  normal,
  processing,
  success,
  failure,
}

extension BrokersOverviewStatusX on BrokersOverviewStatus {
  bool isProcessing() => this == BrokersOverviewStatus.processing;
  bool isSuccess() => this == BrokersOverviewStatus.success;
  bool isFailure() => this == BrokersOverviewStatus.failure;
}

class BrokersOverviewState extends Equatable {
  const BrokersOverviewState({
    required this.isAdmin,
    this.status = BrokersOverviewStatus.normal,
    required this.parentProject,
    this.brokers = const [],
    this.error,
  });

  // immutate
  final bool isAdmin;
  final Project parentProject;

  // listen
  final List<Broker> brokers;

  // status
  final BrokersOverviewStatus status;
  final String? error;

  List<Broker> get showedBrokers =>
      brokers.where((br) => br.projectID == parentProject.id).toList();

  @override
  List<Object?> get props => [isAdmin, status, parentProject, brokers, error];

  BrokersOverviewState copyWith({
    bool? isAdmin,
    BrokersOverviewStatus? status,
    Project? parentProject,
    List<Broker>? brokers,
    String? Function()? error,
  }) {
    return BrokersOverviewState(
      isAdmin: isAdmin ?? this.isAdmin,
      status: status ?? this.status,
      parentProject: parentProject ?? this.parentProject,
      brokers: brokers ?? this.brokers,
      error: error != null ? error() : this.error,
    );
  }
}
