part of 'edit_project_bloc.dart';

enum EditProjectStatus {
  normal,
  processing,
  success,
  failure,
}

extension EditProjectStatusX on EditProjectStatus {
  bool isProcessing() => this == EditProjectStatus.processing;
  bool isSuccess() => this == EditProjectStatus.success;
  bool isFailure() => this == EditProjectStatus.failure;
}

class EditProjectState extends Equatable {
  const EditProjectState({
    this.status = EditProjectStatus.normal,
    this.name = '',
    this.initialProject,
    this.error,
  });

  // input
  final String name;

  // initial
  final Project? initialProject;

  // status
  final EditProjectStatus status;
  final String? error;

  @override
  List<Object?> get props => [name, initialProject, status, error];

  EditProjectState copyWith({
    String? name,
    EditProjectStatus? status,
    Project? initialProject,
    String? Function()? error,
  }) {
    return EditProjectState(
      name: name ?? this.name,
      status: status ?? this.status,
      initialProject: initialProject ?? this.initialProject,
      error: error != null ? error() : this.error,
    );
  }
}
