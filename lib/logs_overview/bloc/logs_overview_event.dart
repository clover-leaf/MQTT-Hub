part of 'logs_overview_bloc.dart';

class LogsOverviewEvent extends Equatable {
  const LogsOverviewEvent();

  @override
  List<Object?> get props => [];
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

class ConditionLogSubscriptionRequested extends LogsOverviewEvent {
  const ConditionLogSubscriptionRequested();
}
