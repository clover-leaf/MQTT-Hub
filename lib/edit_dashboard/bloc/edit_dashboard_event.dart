part of 'edit_dashboard_bloc.dart';

class EditDashboardEvent extends Equatable {
  const EditDashboardEvent();

  @override
  List<Object?> get props => [];
}

class Submitted extends EditDashboardEvent {
  const Submitted();
}

class NameChanged extends EditDashboardEvent {
  const NameChanged(this.name);

  final String name;

  @override
  List<Object> get props => [name];
}
