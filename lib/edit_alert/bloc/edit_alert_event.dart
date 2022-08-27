part of 'edit_alert_bloc.dart';

class EditAlertEvent extends Equatable {
  const EditAlertEvent();

  @override
  List<Object?> get props => [];
}

class Submitted extends EditAlertEvent {
  const Submitted();
}

class NameChanged extends EditAlertEvent {
  const NameChanged(this.name);

  final String name;

  @override
  List<Object> get props => [name];
}

class SelectedDeviceIDChanged extends EditAlertEvent {
  const SelectedDeviceIDChanged(this.selectedDeviceID);

  final FieldId selectedDeviceID;

  @override
  List<Object?> get props => [selectedDeviceID];
}

class ConditionsChanged extends EditAlertEvent {
  const ConditionsChanged(this.conditions);

  final List<Condition> conditions;

  @override
  List<Object?> get props => [conditions];
}

class ActionsChanged extends EditAlertEvent {
  const ActionsChanged(this.actions);

  final List<TAction> actions;

  @override
  List<Object?> get props => [actions];
}
