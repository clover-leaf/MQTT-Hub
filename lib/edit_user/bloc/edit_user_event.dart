part of 'edit_user_bloc.dart';

class EditUserEvent extends Equatable {
  const EditUserEvent();

  @override
  List<Object?> get props => [];
}

class EditSubmitted extends EditUserEvent {
  const EditSubmitted({
    required this.username,
    required this.password,
    required this.selectedProjectIDs,
  });

  final String username;
  final String password;
  final List<FieldId> selectedProjectIDs;

  @override
  List<Object> get props => [username, password, selectedProjectIDs];
}

class EditUsernameChanged extends EditUserEvent {
  const EditUsernameChanged(this.username);

  final String username;

  @override
  List<Object> get props => [username];
}

class EditPasswordChanged extends EditUserEvent {
  const EditPasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

class EditProjectAdded extends EditUserEvent {
  const EditProjectAdded(this.projectID);

  final FieldId projectID;

  @override
  List<Object> get props => [projectID];
}

class EditProjectDeleted extends EditUserEvent {
  const EditProjectDeleted(this.projectID);

  final FieldId projectID;

  @override
  List<Object> get props => [projectID];
}

class ProjectSubscriptionRequested extends EditUserEvent {
  const ProjectSubscriptionRequested();
}
