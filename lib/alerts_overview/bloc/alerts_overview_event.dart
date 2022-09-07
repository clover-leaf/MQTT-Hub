part of 'alerts_overview_bloc.dart';

class AlertsOverviewEvent extends Equatable {
  const AlertsOverviewEvent();

  @override
  List<Object?> get props => [];
}

class AlertSubscriptionRequested extends AlertsOverviewEvent {
  const AlertSubscriptionRequested();
}

class ConditionSubscriptionRequested extends AlertsOverviewEvent {
  const ConditionSubscriptionRequested();
}

class ActionSubscriptionRequested extends AlertsOverviewEvent {
  const ActionSubscriptionRequested();
}

class BrokerSubscriptionRequested extends AlertsOverviewEvent {
  const BrokerSubscriptionRequested();
}

class DeviceSubscriptionRequested extends AlertsOverviewEvent {
  const DeviceSubscriptionRequested();
}

class AttributeSubscriptionRequested extends AlertsOverviewEvent {
  const AttributeSubscriptionRequested();
}

class DeletionRequested extends AlertsOverviewEvent {
  const DeletionRequested(this.alertID);

  final String alertID;

  @override
  List<Object?> get props => [alertID];
}
