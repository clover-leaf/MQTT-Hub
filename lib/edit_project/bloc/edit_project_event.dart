part of 'edit_project_bloc.dart';

class EditProjectEvent extends Equatable {
  const EditProjectEvent();

  @override
  List<Object?> get props => [];
}

class Submitted extends EditProjectEvent {
  const Submitted();
}

class NameChanged extends EditProjectEvent {
  const NameChanged(this.name);

  final String name;

  @override
  List<Object> get props => [name];
}
