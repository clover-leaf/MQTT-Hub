part of 'project_detail_bloc.dart';

class ProjectDetailEvent extends Equatable {
  const ProjectDetailEvent();

  @override
  List<Object?> get props => [];
}

class GroupSubscriptionRequested extends ProjectDetailEvent {
  const GroupSubscriptionRequested();
}

class BrokerSubscriptionRequested extends ProjectDetailEvent {
  const BrokerSubscriptionRequested();
}

class UserProjectSubscriptionRequested extends ProjectDetailEvent {
  const UserProjectSubscriptionRequested();
}

class DashboardSubscriptionRequested extends ProjectDetailEvent {
  const DashboardSubscriptionRequested();
}

class DeviceSubscriptionRequested extends ProjectDetailEvent {
  const DeviceSubscriptionRequested();
}

class DeviceTypeSubscriptionRequested extends ProjectDetailEvent {
  const DeviceTypeSubscriptionRequested();
}

class AlertSubscriptionRequested extends ProjectDetailEvent {
  const AlertSubscriptionRequested();
}

class ScheduleSubscriptionRequested extends ProjectDetailEvent {
  const ScheduleSubscriptionRequested();
}

class DeletionRequested extends ProjectDetailEvent {
  const DeletionRequested();
}
