part of 'tiles_overview_bloc.dart';

class TilesOverviewEvent extends Equatable {
  const TilesOverviewEvent();

  @override
  List<Object?> get props => [];
}

class InitializationRequested extends TilesOverviewEvent {
  const InitializationRequested();
}

class TileDeletedRequested extends TilesOverviewEvent {
  const TileDeletedRequested(this.tileID);

  final String tileID;

  @override
  List<Object?> get props => [tileID];
}

class BrokerConnectionRequested extends TilesOverviewEvent {
  const BrokerConnectionRequested(this.gatewayClient);

  final GatewayClient gatewayClient;

  @override
  List<Object?> get props => [gatewayClient];
}

class GatewayStatusSubscriptionRequested extends TilesOverviewEvent {
  const GatewayStatusSubscriptionRequested(this.gatewayClient);

  final GatewayClient gatewayClient;

  @override
  List<Object?> get props => [gatewayClient];
}

class GatewayStatusCloseSubscriptionRequested extends TilesOverviewEvent {
  const GatewayStatusCloseSubscriptionRequested(this.gatewayClient);

  final GatewayClient gatewayClient;

  @override
  List<Object?> get props => [gatewayClient];
}

class GatewayListenRequested extends TilesOverviewEvent {
  const GatewayListenRequested(this.gatewayClient);

  final GatewayClient gatewayClient;

  @override
  List<Object?> get props => [gatewayClient];
}

class GatewayPublishRequested extends TilesOverviewEvent {
  const GatewayPublishRequested({
    required this.deviceID,
    required this.attributeID,
    required this.value,
  });

  final FieldId deviceID;
  final FieldId attributeID;
  final String value;

  @override
  List<Object?> get props => [deviceID, attributeID, value];
}

class BrokerSubscriptionRequested extends TilesOverviewEvent {
  const BrokerSubscriptionRequested();
}

class ProjectSubscriptionRequested extends TilesOverviewEvent {
  const ProjectSubscriptionRequested();
}

class DashboardSubscriptionRequested extends TilesOverviewEvent {
  const DashboardSubscriptionRequested();
}

class TileSubscriptionRequested extends TilesOverviewEvent {
  const TileSubscriptionRequested();
}

class ActionSubscriptionRequested extends TilesOverviewEvent {
  const ActionSubscriptionRequested();
}

class ActionTileSubscriptionRequested extends TilesOverviewEvent {
  const ActionTileSubscriptionRequested();
}

class DeviceTypeSubscriptionRequested extends TilesOverviewEvent {
  const DeviceTypeSubscriptionRequested();
}

class DeviceSubscriptionRequested extends TilesOverviewEvent {
  const DeviceSubscriptionRequested();
}

class AttributeSubscriptionRequested extends TilesOverviewEvent {
  const AttributeSubscriptionRequested();
}

class SelectedProjectChanged extends TilesOverviewEvent {
  const SelectedProjectChanged(this.projectID);

  final FieldId projectID;

  @override
  List<Object?> get props => [projectID];
}

class SelectedDashboardChanged extends TilesOverviewEvent {
  const SelectedDashboardChanged(this.dashboardID);

  final FieldId dashboardID;

  @override
  List<Object?> get props => [dashboardID];
}

class LogoutRequested extends TilesOverviewEvent {
  const LogoutRequested();
}
