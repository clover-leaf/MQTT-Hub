part of 'dashboards_overview_bloc.dart';

class DashboardsOverviewEvent extends Equatable {
  const DashboardsOverviewEvent();

  @override
  List<Object?> get props => [];
}

class DashboardSubscriptionRequested extends DashboardsOverviewEvent {
  const DashboardSubscriptionRequested();
}

class DeletionRequested extends DashboardsOverviewEvent {
  const DeletionRequested(this.dashboardID);

  final String dashboardID;

  @override
  List<Object?> get props => [dashboardID];
}
