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

class UserAdded extends UsersOverviewEvent {
  const UserAdded({required this.user, required this.project});

  final User user;
  final Project project;

  @override
  List<Object?> get props => [user, project];
}
