part of 'projects_overview_bloc.dart';

class ProjectsOverviewEvent extends Equatable {
  const ProjectsOverviewEvent();

  @override
  List<Object?> get props => [];
}

class ProjectSubscriptionRequested extends ProjectsOverviewEvent {
  const ProjectSubscriptionRequested();
}

class BrokerSubscriptionRequested extends ProjectsOverviewEvent {
  const BrokerSubscriptionRequested();
}

class UserProjectSubscriptionRequested extends ProjectsOverviewEvent {
  const UserProjectSubscriptionRequested();
}

class DashboardSubscriptionRequested extends ProjectsOverviewEvent {
  const DashboardSubscriptionRequested();
}
