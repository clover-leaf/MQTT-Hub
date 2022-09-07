part of 'logs_overview_bloc.dart';

class LogsOverviewState extends Equatable {
  LogsOverviewState({
    this.logs = const [],
    this.conditionLogs = const [],
    this.conditions = const [],
    this.attributes = const [],
    this.alerts = const [],
    this.devices = const [],
  });

  // lister
  final List<Log> logs;
  final List<Condition> conditions;
  final List<ConditionLog> conditionLogs;
  final List<Attribute> attributes;
  final List<Alert> alerts;
  final List<Device> devices;

  late final Map<String, Device> deviceView = {
    for (final dv in devices) dv.id: dv
  };
  late final Map<String, Attribute> attributeView = {
    for (final att in attributes) att.id: att
  };
  late final Map<String, Alert> alertView = 
  {for (final al in alerts) al.id: al};
  late final Map<String, Log> logView = {for (final lg in logs) lg.id: lg};
  late final Map<String, Condition> conditionView = {
    for (final cd in conditions) cd.id: cd
  };

  @override
  List<Object> get props =>
      [logs, conditionLogs, conditions, attributes, alerts, devices];

  LogsOverviewState copyWith({
    List<Log>? logs,
    List<ConditionLog>? conditionLogs,
    List<Condition>? conditions,
    List<Attribute>? attributes,
    List<Alert>? alerts,
    List<Device>? devices,
  }) {
    return LogsOverviewState(
      logs: logs ?? this.logs,
      conditionLogs: conditionLogs ?? this.conditionLogs,
      conditions: conditions ?? this.conditions,
      attributes: attributes ?? this.attributes,
      alerts: alerts ?? this.alerts,
      devices: devices ?? this.devices,
    );
  }
}
