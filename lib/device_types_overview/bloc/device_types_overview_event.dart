part of 'device_types_overview_bloc.dart';

class DeviceTypesOverviewEvent extends Equatable {
  const DeviceTypesOverviewEvent();

  @override
  List<Object?> get props => [];
}

class DeviceTypeSubscriptionRequested extends DeviceTypesOverviewEvent {
  const DeviceTypeSubscriptionRequested();
}

class AttributeSubscriptionRequested extends DeviceTypesOverviewEvent {
  const AttributeSubscriptionRequested();
}

class DeletionRequested extends DeviceTypesOverviewEvent {
  const DeletionRequested(this.deviceTypeID);

  final String deviceTypeID;

  @override
  List<Object?> get props => [deviceTypeID];
}
