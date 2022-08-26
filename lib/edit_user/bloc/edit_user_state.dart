part of 'edit_user_bloc.dart';

enum EditUserStatus {
  normal,
  processing,
  success,
  failure,
}

extension EditUserStatusX on EditUserStatus {
  bool isProcessing() => this == EditUserStatus.processing;
  bool isSuccess() => this == EditUserStatus.success;
  bool isFailure() => this == EditUserStatus.failure;
}

class EditUserState extends Equatable {
  const EditUserState({
    this.status = EditUserStatus.normal,
    required this.initialUserProjects,
    required this.initialProjects,
    required this.userProjects,
    required this.userID,
    this.username = '',
    this.password = '',
    this.initialUser,
    this.error,
  });

  // immutate
  final List<UserProject> initialUserProjects;
  final List<Project> initialProjects;
  
  // initial
  final User? initialUser;

  // create
  final String userID;

  // choose
  final List<UserProject> userProjects;

  // input
  final String username;
  final String password;

  // status
  final EditUserStatus status;
  final String? error;

  @override
  List<Object?> get props => [
        initialUserProjects,
        initialProjects,
        userID,
        username,
        password,
        userProjects,
        status,
        initialUser,
        error
      ];

  EditUserState copyWith({
    List<UserProject>? initialUserProjects,
    List<Project>? initialProjects,
    String? userID,
    String? username,
    String? password,
    List<UserProject>? userProjects,
    EditUserStatus? status,
    User? initialUser,
    String? Function()? error,
  }) {
    return EditUserState(
      initialUserProjects: initialUserProjects ?? this.initialUserProjects,
      initialProjects: initialProjects ?? this.initialProjects,
      userID: userID ?? this.userID,
      username: username ?? this.username,
      password: password ?? this.password,
      userProjects: userProjects ?? this.userProjects,
      status: status ?? this.status,
      initialUser: initialUser ?? this.initialUser,
      error: error != null ? error() : this.error,
    );
  }
}
