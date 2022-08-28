part of 'logs_overview_bloc.dart';

class LogsOverviewState extends Equatable {
  LogsOverviewState({
    this.logs = const [],
    this.conditionLogs = const [],
    this.attributes = const [],
    this.alerts = const [],
    this.devices = const [],
  });

  // lister
  final List<Log> logs;
  final List<ConditionLog> conditionLogs;
  final List<Attribute> attributes;
  final List<Alert> alerts;
  final List<Device> devices;

  late Map<String, Device> deviceView = {for (final dv in devices) dv.id: dv};
  late Map<String, Attribute> attributeView = {
    for (final att in attributes) att.id: att
  };
  late Map<String, Alert> alertView = {for (final al in alerts) al.id: al};
  late Map<String, Log> logView = {for (final lg in logs) lg.id: lg};

  @override
  List<Object> get props => [logs, conditionLogs, attributes, alerts, devices];

  LogsOverviewState copyWith({
    List<Log>? logs,
    List<ConditionLog>? conditionLogs,
    List<Attribute>? attributes,
    List<Alert>? alerts,
    List<Device>? devices,
  }) {
    return LogsOverviewState(
      logs: logs ?? this.logs,
      conditionLogs: conditionLogs ?? this.conditionLogs,
      attributes: attributes ?? this.attributes,
      alerts: alerts ?? this.alerts,
      devices: devices ?? this.devices,
    );
  }
}
