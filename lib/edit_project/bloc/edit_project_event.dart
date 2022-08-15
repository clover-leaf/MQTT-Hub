part of 'edit_project_bloc.dart';

class EditProjectEvent extends Equatable {
  const EditProjectEvent();

  @override
  List<Object?> get props => [];
}

class EditSubmitted extends EditProjectEvent {
  const EditSubmitted({
    required this.projectName,
  });

  final String projectName;

  @override
  List<Object> get props => [projectName];
}

class EditProjectNameChanged extends EditProjectEvent {
  const EditProjectNameChanged(this.projectName);

  final String projectName;

  @override
  List<Object> get props => [projectName];
}
