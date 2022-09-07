part of 'schedules_overview_bloc.dart';

enum SchedulesOverviewStatus {
  normal,
  processing,
  success,
  failure,
}

extension SchedulesOverviewStatusX on SchedulesOverviewStatus {
  bool isProcessing() => this == SchedulesOverviewStatus.processing;
  bool isSuccess() => this == SchedulesOverviewStatus.success;
  bool isFailure() => this == SchedulesOverviewStatus.failure;
}

class SchedulesOverviewState extends Equatable {
  const SchedulesOverviewState({
    required this.isAdmin,
    this.status = SchedulesOverviewStatus.normal,
    required this.parentProject,
    this.schedules = const [],
    this.actions = const [],
    this.brokers = const [],
    this.devices = const [],
    this.attributes = const [],
    this.error,
  });

  // immutate
  final bool isAdmin;
  final Project parentProject;

  // listen
  final List<Schedule> schedules;
  final List<Broker> brokers;
  final List<TAction> actions;
  final List<Device> devices;
  final List<Attribute> attributes;

  // status
  final SchedulesOverviewStatus status;
  final String? error;

  List<Schedule> get showedSchedule =>
      schedules.where((sc) => sc.projectID == parentProject.id).toList();

  List<Broker> get brokerInProject =>
      brokers.where((br) => br.projectID == parentProject.id).toList();

  List<Device> get deviceInProject => devices.where((dv) {
        final brokerIdInProject = brokerInProject.map((br) => br.id);
        return brokerIdInProject.contains(dv.brokerID);
      }).toList();
      
  @override
  List<Object?> get props => [
        isAdmin,
        status,
        brokers,
        schedules,
        actions,
        devices,
        attributes,
        parentProject,
        error
      ];

  SchedulesOverviewState copyWith({
    bool? isAdmin,
    SchedulesOverviewStatus? status,
    Project? parentProject,
    List<Schedule>? schedules,
    List<Broker>? brokers,
    List<TAction>? actions,
    List<Device>? devices,
    List<Attribute>? attributes,
    String? Function()? error,
  }) {
    return SchedulesOverviewState(
      isAdmin: isAdmin ?? this.isAdmin,
      status: status ?? this.status,
      parentProject: parentProject ?? this.parentProject,
      schedules: schedules ?? this.schedules,
      brokers: brokers ?? this.brokers,
      actions: actions ?? this.actions,
      devices: devices ?? this.devices,
      attributes: attributes ?? this.attributes,
      error: error != null ? error() : this.error,
    );
  }
}
