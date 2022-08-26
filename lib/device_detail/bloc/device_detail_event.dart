part of 'device_detail_bloc.dart';

class DeviceDetailEvent extends Equatable {
  const DeviceDetailEvent();

  @override
  List<Object?> get props => [];
}

class AttributeSubscriptionRequested extends DeviceDetailEvent {
  const AttributeSubscriptionRequested();
}

class BrokerSubscriptionRequested extends DeviceDetailEvent {
  const BrokerSubscriptionRequested();
}

class DeviceSubscriptionRequested extends DeviceDetailEvent {
  const DeviceSubscriptionRequested();
}

class DeletionRequested extends DeviceDetailEvent {
  const DeletionRequested();
}
