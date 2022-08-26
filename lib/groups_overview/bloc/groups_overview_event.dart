part of 'groups_overview_bloc.dart';

class GroupsOverviewEvent extends Equatable {
  const GroupsOverviewEvent();

  @override
  List<Object?> get props => [];
}

class GroupSubscriptionRequested extends GroupsOverviewEvent {
  const GroupSubscriptionRequested();
}

class DeviceSubscriptionRequested extends GroupsOverviewEvent {
  const DeviceSubscriptionRequested();
}
