part of 'users_overview_bloc.dart';

class UsersOverviewState extends Equatable {
  const UsersOverviewState({
    required this.parentProject,
    this.users = const [],
    this.userProjects = const [],
    this.error = '',
  });

  final Project? parentProject;
  final List<User> users;
  final List<UserProject> userProjects;
  final String error;

  List<User> get showedUsers {
    if (parentProject == null) return users;
    final showUserProjectIDs = userProjects
        .where((usPr) => usPr.projectID == parentProject!.id)
        .map((usPr) => usPr.userID);
    final showedUsers =
        users.where((user) => showUserProjectIDs.contains(user.id)).toList();
    return showedUsers;
  }

  @override
  List<Object?> get props => [parentProject, users, userProjects, error];

  UsersOverviewState copyWith({
    Project? parentProject,
    List<User>? users,
    List<UserProject>? userProjects,
    String? error,
  }) {
    return UsersOverviewState(
      parentProject: parentProject ?? this.parentProject,
      users: users ?? this.users,
      userProjects: userProjects ?? this.userProjects,
      error: error ?? this.error,
    );
  }
}
