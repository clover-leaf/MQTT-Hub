part of 'schedules_overview_bloc.dart';

class SchedulesOverviewEvent extends Equatable {
  const SchedulesOverviewEvent();

  @override
  List<Object?> get props => [];
}

class BrokerSubscriptionRequested extends SchedulesOverviewEvent {
  const BrokerSubscriptionRequested();
}

class ScheduleSubscriptionRequested extends SchedulesOverviewEvent {
  const ScheduleSubscriptionRequested();
}

class ActionSubscriptionRequested extends SchedulesOverviewEvent {
  const ActionSubscriptionRequested();
}

class DeviceSubscriptionRequested extends SchedulesOverviewEvent {
  const DeviceSubscriptionRequested();
}

class AttributeSubscriptionRequested extends SchedulesOverviewEvent {
  const AttributeSubscriptionRequested();
}

class DeletionRequested extends SchedulesOverviewEvent {
  const DeletionRequested(this.scheduleID);

  final String scheduleID;

  @override
  List<Object?> get props => [scheduleID];
}
