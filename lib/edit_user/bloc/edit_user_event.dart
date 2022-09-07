part of 'edit_user_bloc.dart';

class EditUserEvent extends Equatable {
  const EditUserEvent();

  @override
  List<Object?> get props => [];
}

class Submitted extends EditUserEvent {
  const Submitted();
}

class UsernameChanged extends EditUserEvent {
  const UsernameChanged(this.username);

  final String username;

  @override
  List<Object> get props => [username];
}

class IsEditChanged extends EditUserEvent {
  const IsEditChanged({required this.isEdit});

  final bool isEdit;

  @override
  List<Object> get props => [isEdit];
}


class PasswordChanged extends EditUserEvent {
  const PasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

class UserProjectsChanged extends EditUserEvent {
  const UserProjectsChanged(this.userProjects);

  final List<UserProject> userProjects;

  @override
  List<Object> get props => [userProjects];
}
