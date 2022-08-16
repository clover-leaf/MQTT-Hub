part of 'edit_user_bloc.dart';

class EditUserState extends Equatable {
  const EditUserState({
    required this.initUserProjects,
    required this.selectedProjectIDs,
    this.projects = const [],
    this.username = const Username.pure(),
    this.password = const Password.pure(),
    this.status = FormzStatus.pure,
    this.valid = false,
    this.initUser,
    this.error,
  });

  final List<UserProject> initUserProjects;
  final List<FieldId> selectedProjectIDs;
  final List<Project> projects;
  final Username username;
  final Password password;
  final FormzStatus status;
  final User? initUser;
  final bool valid;
  final String? error;

  @override
  List<Object?> get props => [
        initUserProjects,
        selectedProjectIDs,
        projects,
        username,
        password,
        status,
        initUser,
        valid,
        error
      ];

  EditUserState copyWith({
    List<FieldId>? selectedProjectIDs,
    List<UserProject>? initUserProjects,
    List<Project>? projects,
    Username? username,
    Password? password,
    FormzStatus? status,
    bool? valid,
    User? initUser,
    String? error,
  }) {
    return EditUserState(
      initUserProjects: initUserProjects ?? this.initUserProjects,
      selectedProjectIDs: selectedProjectIDs ?? this.selectedProjectIDs,
      projects: projects ?? this.projects,
      username: username ?? this.username,
      password: password ?? this.password,
      status: status ?? this.status,
      valid: valid ?? this.valid,
      initUser: initUser ?? this.initUser,
      error: error ?? this.error,
    );
  }
}
