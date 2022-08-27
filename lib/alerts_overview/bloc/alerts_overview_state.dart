part of 'alerts_overview_bloc.dart';

enum AlertsOverviewStatus {
  normal,
  processing,
  success,
  failure,
}

extension AlertsOverviewStatusX on AlertsOverviewStatus {
  bool isProcessing() => this == AlertsOverviewStatus.processing;
  bool isSuccess() => this == AlertsOverviewStatus.success;
  bool isFailure() => this == AlertsOverviewStatus.failure;
}

class AlertsOverviewState extends Equatable {
  const AlertsOverviewState({
    required this.isAdmin,
    this.status = AlertsOverviewStatus.normal,
    required this.parentProject,
    this.alerts = const [],
    this.conditions = const [],
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
  final List<Alert> alerts;
  final List<Condition> conditions;
  final List<TAction> actions;
  final List<Broker> brokers;
  final List<Device> devices;
  final List<Attribute> attributes;

  // status
  final AlertsOverviewStatus status;
  final String? error;

  List<Broker> get brokerInProject => brokers.where((br) => br.projectID == parentProject.id).toList();

  List<Device> get deviceInProject => devices.where((dv) {
    final brokerIdInProject = brokerInProject.map((br) => br.id);
    return brokerIdInProject.contains(dv.brokerID);    
  }).toList();

  List<Attribute> get attributeInProject => attributes.where((att) {
    final deviceIdInProject = deviceInProject.map((dv) => dv.id);
    return deviceIdInProject.contains(att.deviceID);    
  }).toList();

  List<Alert> get showedAlerts {
    final brokerIDinProjet = brokers
        .where((br) => br.projectID == parentProject.id)
        .map((br) => br.id)
        .toList();
    final deviceView = {for (final dv in devices) dv.id: dv};
    final showedAlerts = alerts.where((al) {
      final device = deviceView[al.deviceID];
      return brokerIDinProjet.contains(device?.brokerID);
    }).toList();
    return showedAlerts;
  }

  @override
  List<Object?> get props => [
        isAdmin,
        parentProject,
        status,
        alerts,
        conditions,
        actions,
        brokers,
        devices,
        attributes,
        error
      ];

  AlertsOverviewState copyWith({
    bool? isAdmin,
    AlertsOverviewStatus? status,
    Project? parentProject,
    List<Alert>? alerts,
    List<Condition>? conditions,
    List<TAction>? actions,
    List<Broker>? brokers,
    List<Device>? devices,
    List<Attribute>? attributes,
    String? Function()? error,
  }) {
    return AlertsOverviewState(
      isAdmin: isAdmin ?? this.isAdmin,
      parentProject: parentProject ?? this.parentProject,
      status: status ?? this.status,
      alerts: alerts ?? this.alerts,
      conditions: conditions ?? this.conditions,
      actions: actions ?? this.actions,
      brokers: brokers ?? this.brokers,
      devices: devices ?? this.devices,
      attributes: attributes ?? this.attributes,
      error: error != null ? error() : this.error,
    );
  }
}
