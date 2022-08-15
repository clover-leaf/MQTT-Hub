part of 'edit_project_bloc.dart';

class EditProjectState extends Equatable {
  const EditProjectState({
    this.projectName = const ProjectName.pure(),
    this.status = FormzStatus.pure,
    this.valid = false,
    this.initProject,
    this.error,
  });

  final ProjectName projectName;
  final FormzStatus status;
  final bool valid;
  final Project? initProject;
  final String? error;

  @override
  List<Object?> get props => [projectName, initProject, status, valid, error];

  EditProjectState copyWith({
    ProjectName? projectName,
    FormzStatus? status,
    bool? valid,
    Project? initProject,
    String? error,
  }) {
    return EditProjectState(
      projectName: projectName ?? this.projectName,
      status: status ?? this.status,
      valid: valid ?? this.valid,
      initProject: initProject ?? this.initProject,
      error: error ?? this.error,
    );
  }
}
