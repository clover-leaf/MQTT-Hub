part of 'edit_group_bloc.dart';

class EditGroupEvent extends Equatable {
  const EditGroupEvent();

  @override
  List<Object?> get props => [];
}

class Submitted extends EditGroupEvent {
  const Submitted();
}

class NameChanged extends EditGroupEvent {
  const NameChanged(this.name);

  final String name;

  @override
  List<Object> get props => [name];
}

class DescriptionChanged extends EditGroupEvent {
  const DescriptionChanged(this.description);

  final String description;

  @override
  List<Object> get props => [description];
}
