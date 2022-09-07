part of 'logs_overview_bloc.dart';

class LogsOverviewEvent extends Equatable {
  const LogsOverviewEvent();

  @override
  List<Object?> get props => [];
}

class GetLogsRequested extends LogsOverviewEvent {
  const GetLogsRequested();
}

class DeviceSubscriptionRequested extends LogsOverviewEvent {
  const DeviceSubscriptionRequested();
}

class AttributeSubscriptionRequested extends LogsOverviewEvent {
  const AttributeSubscriptionRequested();
}

class AlertSubscriptionRequested extends LogsOverviewEvent {
  const AlertSubscriptionRequested();
}

class LogSubscriptionRequested extends LogsOverviewEvent {
  const LogSubscriptionRequested();
}

class ConditionSubscriptionRequested extends LogsOverviewEvent {
  const ConditionSubscriptionRequested();
}

class ConditionLogSubscriptionRequested extends LogsOverviewEvent {
  const ConditionLogSubscriptionRequested();
}
