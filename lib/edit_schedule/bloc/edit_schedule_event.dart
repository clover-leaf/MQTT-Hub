part of 'edit_schedule_bloc.dart';

class EditScheduleEvent extends Equatable {
  const EditScheduleEvent();

  @override
  List<Object?> get props => [];
}

class Submitted extends EditScheduleEvent {
  const Submitted();
}

class NameChanged extends EditScheduleEvent {
  const NameChanged(this.name);

  final String name;

  @override
  List<Object> get props => [name];
}

class TimeChanged extends EditScheduleEvent {
  const TimeChanged(this.time);

  final DateTime time;

  @override
  List<Object> get props => [time];
}

class DateChanged extends EditScheduleEvent {
  const DateChanged(this.date);

  final DateTime date;

  @override
  List<Object> get props => [date];
}

class IsRepeatChanged extends EditScheduleEvent {
  const IsRepeatChanged({required this.isRepeat});

  final bool isRepeat;

  @override
  List<Object> get props => [isRepeat];
}

class DayOfWeekChanged extends EditScheduleEvent {
  const DayOfWeekChanged(this.dayOfWeeks);

  final List<int> dayOfWeeks;

  @override
  List<Object> get props => [dayOfWeeks];
}

class ActionsChanged extends EditScheduleEvent {
  const ActionsChanged(this.actions);

  final List<TAction> actions;

  @override
  List<Object?> get props => [actions];
}

class IsEditChanged extends EditScheduleEvent {
  const IsEditChanged({required this.isEdit});

  final bool isEdit;

  @override
  List<Object> get props => [isEdit];
}
