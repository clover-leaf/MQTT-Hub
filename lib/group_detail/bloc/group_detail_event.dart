part of 'group_detail_bloc.dart';

class GroupDetailEvent extends Equatable {
  const GroupDetailEvent();

  @override
  List<Object?> get props => [];
}

class BrokerSubscriptionRequested extends GroupDetailEvent {
  const BrokerSubscriptionRequested();
}

class GroupSubscriptionRequested extends GroupDetailEvent {
  const GroupSubscriptionRequested();
}

class DeviceSubscriptionRequested extends GroupDetailEvent {
  const DeviceSubscriptionRequested();
}

class DeletionRequested extends GroupDetailEvent {
  const DeletionRequested();
}

class GroupVisibilityChanged extends GroupDetailEvent {
  const GroupVisibilityChanged({required this.isVisible});

  final bool isVisible;

  @override
  List<Object?> get props => [isVisible];
}

class DeviceVisibilityChanged extends GroupDetailEvent {
  const DeviceVisibilityChanged({required this.isVisible});

  final bool isVisible;

  @override
  List<Object?> get props => [isVisible];
}
