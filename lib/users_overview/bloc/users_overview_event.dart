part of 'users_overview_bloc.dart';

class UsersOverviewEvent extends Equatable {
  const UsersOverviewEvent();

  @override
  List<Object?> get props => [];
}

class UserSubscriptionRequested extends UsersOverviewEvent {
  const UserSubscriptionRequested();
}

class UserProjectSubscriptionRequested extends UsersOverviewEvent {
  const UserProjectSubscriptionRequested();
}

class ProjectSubscriptionRequested extends UsersOverviewEvent {
  const ProjectSubscriptionRequested();
}

class DeletionRequested extends UsersOverviewEvent {
  const DeletionRequested(this.userID);

  final String userID;

  @override
  List<Object?> get props => [userID];
}
