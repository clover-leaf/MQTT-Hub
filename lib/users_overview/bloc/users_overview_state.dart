part of 'users_overview_bloc.dart';

enum UsersOverviewStatus {
  normal,
  processing,
  success,
  failure,
}

extension UsersOverviewStatusX on UsersOverviewStatus {
  bool isProcessing() => this == UsersOverviewStatus.processing;
  bool isSuccess() => this == UsersOverviewStatus.success;
  bool isFailure() => this == UsersOverviewStatus.failure;
}

class UsersOverviewState extends Equatable {
  const UsersOverviewState({
    required this.isAdmin,
    this.status = UsersOverviewStatus.normal,
    required this.parentProject,
    this.users = const [],
    this.projects = const [],
    this.userProjects = const [],
    this.error,
  });

  // immutate
  final bool isAdmin;
  final Project? parentProject;

  // listen
  final List<User> users;
  final List<Project> projects;
  final List<UserProject> userProjects;

  // status
  final UsersOverviewStatus status;
  final String? error;

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
  List<Object?> get props =>
      [isAdmin, status, parentProject, users, projects, userProjects, error];

  UsersOverviewState copyWith({
    bool? isAdmin,
    UsersOverviewStatus? status,
    Project? parentProject,
    List<User>? users,
    List<Project>? projects,
    List<UserProject>? userProjects,
    String? Function()? error,
  }) {
    return UsersOverviewState(
      isAdmin: isAdmin ?? this.isAdmin,
      status: status ?? this.status,
      parentProject: parentProject ?? this.parentProject,
      users: users ?? this.users,
      projects: projects ?? this.projects,
      userProjects: userProjects ?? this.userProjects,
      error: error != null ? error() : this.error,
    );
  }
}
