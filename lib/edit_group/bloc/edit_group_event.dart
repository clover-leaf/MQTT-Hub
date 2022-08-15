part of 'edit_group_bloc.dart';

class EditGroupEvent extends Equatable {
  const EditGroupEvent();

  @override
  List<Object?> get props => [];
}

class EditSubmitted extends EditGroupEvent {
  const EditSubmitted({
    required this.groupName,
  });

  final String groupName;

  @override
  List<Object> get props => [groupName];
}

class EditGroupNameChanged extends EditGroupEvent {
  const EditGroupNameChanged(this.groupName);

  final String groupName;

  @override
  List<Object> get props => [groupName];
}
