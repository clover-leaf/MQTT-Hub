part of 'group_detail_bloc.dart';

class GroupDetailEvent extends Equatable {
  const GroupDetailEvent();

  @override
  List<Object?> get props => [];
}

class GroupSubscriptionRequested extends GroupDetailEvent {
  const GroupSubscriptionRequested();
}

class DeviceSubscriptionRequested extends GroupDetailEvent {
  const DeviceSubscriptionRequested();
}
