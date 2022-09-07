part of 'edit_group_bloc.dart';

enum EditGroupStatus {
  normal,
  processing,
  success,
  failure,
}

extension EditGroupStatusX on EditGroupStatus {
  bool isProcessing() => this == EditGroupStatus.processing;
  bool isSuccess() => this == EditGroupStatus.success;
  bool isFailure() => this == EditGroupStatus.failure;
}

class EditGroupState extends Equatable {
  const EditGroupState({
    this.status = EditGroupStatus.normal,
    required this.parentProjetID,
    required this.parentGroupID,
    this.name = '',
    this.description,
    this.initialGroup,
    this.error,
  });

  // immutate
  final String? parentProjetID;
  final String? parentGroupID;

  // input
  final String name;
  final String? description;

  // status
  final EditGroupStatus status;
  final String? error;

  // initial
  final Group? initialGroup;

  @override
  List<Object?> get props => [
        parentProjetID,
        parentGroupID,
        name,
        description,
        initialGroup,
        status,
        error
      ];

  EditGroupState copyWith({
    String? parentProjetID,
    String? parentGroupID,
    String? name,
    String? description,
    EditGroupStatus? status,
    Group? initialGroup,
    String? Function()? error,
  }) {
    return EditGroupState(
      parentProjetID: parentProjetID ?? this.parentProjetID,
      parentGroupID: parentGroupID ?? this.parentGroupID,
      name: name ?? this.name,
      description: description ?? this.description,
      status: status ?? this.status,
      initialGroup: initialGroup ?? this.initialGroup,
      error: error != null ? error() : this.error,
    );
  }
}
