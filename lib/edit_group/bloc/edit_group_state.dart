part of 'edit_group_bloc.dart';

class EditGroupState extends Equatable {
  const EditGroupState({
    required this.project,
    required this.group,
    this.groupName = const GroupName.pure(),
    this.status = FormzStatus.pure,
    this.valid = false,
    this.initGroup,
    this.error,
  });

  final Project? project;
  final Group? group;
  final GroupName groupName;
  final FormzStatus status;
  final Group? initGroup;
  final bool valid;
  final String? error;

  @override
  List<Object?> get props =>
      [project, group, groupName, initGroup, status, valid, error];

  EditGroupState copyWith({
    Project? project,
    Group? group,
    GroupName? groupName,
    FormzStatus? status,
    bool? valid,
    Group? initGroup,
    String? error,
  }) {
    return EditGroupState(
      project: project ?? this.project,
      group: group ?? this.group,
      groupName: groupName ?? this.groupName,
      status: status ?? this.status,
      valid: valid ?? this.valid,
      initGroup: initGroup ?? this.initGroup,
      error: error ?? this.error,
    );
  }
}
