part of 'edit_dashboard_bloc.dart';

enum EditDashboardStatus {
  normal,
  processing,
  success,
  failure,
}

extension EditDashboardStatusX on EditDashboardStatus {
  bool isProcessing() => this == EditDashboardStatus.processing;
  bool isSuccess() => this == EditDashboardStatus.success;
  bool isFailure() => this == EditDashboardStatus.failure;
}

class EditDashboardState extends Equatable {
  const EditDashboardState({
    this.status = EditDashboardStatus.normal,
    required this.parentProject,
    required this.name,
    this.initialDashboard,
    this.error,
  });

  // immutate
  final Project parentProject;

  // input
  final String name;

  // initial
  final Dashboard? initialDashboard;

  // status
  final EditDashboardStatus status;
  final String? error;

  @override
  List<Object?> get props =>
      [parentProject, initialDashboard, name, status, error];

  EditDashboardState copyWith({
    EditDashboardStatus? status,
    Project? parentProject,
    Dashboard? initialDashboard,
    String? name,
    String? Function()? error,
  }) {
    return EditDashboardState(
      status: status ?? this.status,
      parentProject: parentProject ?? this.parentProject,
      initialDashboard: initialDashboard ?? this.initialDashboard,
      name: name ?? this.name,
      error: error != null ? error() : this.error,
    );
  }
}
