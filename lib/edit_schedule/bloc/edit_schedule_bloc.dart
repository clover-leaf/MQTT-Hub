import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'edit_schedule_event.dart';
part 'edit_schedule_state.dart';

class EditScheduleBloc extends Bloc<EditScheduleEvent, EditScheduleState> {
  EditScheduleBloc(
    this._userRepository, {
    required Project parentProject,
    required String initialID,
    required List<Device> devices,
    required List<Attribute> attributes,
    required List<TAction> initialActions,
    required Schedule? initialSchedule,
    required List<int> dayOfWeeks,
    required bool isAdmin,
    required bool isEdit,
  }) : super(
          EditScheduleState(
            isEdit: isEdit,
            isAdmin: isAdmin,
            parentProject: parentProject,
            id: initialID,
            devices: devices,
            attributes: attributes,
            initialActions: initialActions,
            initialSchedule: initialSchedule,
            name: initialSchedule?.name ?? '',
            time: initialSchedule?.time ?? DateTime.now(),
            date: initialSchedule?.date ?? DateTime.now(),
            isRepeat: initialSchedule?.isRepeat ?? false,
            dayOfWeeks: dayOfWeeks,
            actions: initialActions,
          ),
        ) {
    on<Submitted>(_onSubmitted);
    on<IsEditChanged>(_onIsEditChanged);
    on<NameChanged>(_onNameChanged);
    on<TimeChanged>(_onTimeChanged);
    on<DateChanged>(_onDateChanged);
    on<IsRepeatChanged>(_onIsRepeatChanged);
    on<DayOfWeekChanged>(_onDayOfWeekChanged);
    on<ActionsChanged>(_onActionsChanged);
  }

  final UserRepository _userRepository;

  void _onIsEditChanged(IsEditChanged event, Emitter<EditScheduleState> emit) {
    emit(state.copyWith(isEdit: event.isEdit));
  }

  void _onNameChanged(NameChanged event, Emitter<EditScheduleState> emit) {
    emit(state.copyWith(name: event.name));
  }

  void _onTimeChanged(TimeChanged event, Emitter<EditScheduleState> emit) {
    emit(state.copyWith(time: event.time));
  }

  void _onDateChanged(DateChanged event, Emitter<EditScheduleState> emit) {
    emit(state.copyWith(date: event.date));
  }

  void _onIsRepeatChanged(
    IsRepeatChanged event,
    Emitter<EditScheduleState> emit,
  ) {
    emit(state.copyWith(isRepeat: event.isRepeat));
  }

  void _onDayOfWeekChanged(
    DayOfWeekChanged event,
    Emitter<EditScheduleState> emit,
  ) {
    emit(state.copyWith(dayOfWeeks: event.dayOfWeeks));
  }

  void _onActionsChanged(
    ActionsChanged event,
    Emitter<EditScheduleState> emit,
  ) {
    emit(state.copyWith(actions: event.actions));
  }

  Future<void> _onSubmitted(
    Submitted event,
    Emitter<EditScheduleState> emit,
  ) async {
    try {
      emit(state.copyWith(status: EditScheduleStatus.processing));
      final schedule = state.initialSchedule?.copyWith(
            projectID: state.parentProject.id,
            name: state.name,
            time: state.time,
            date: state.date,
            isRepeat: state.isRepeat,
            dayOfWeeks: state.dayOfWeeks.join(','),
          ) ??
          Schedule(
            id: state.id,
            projectID: state.parentProject.id,
            name: state.name,
            time: state.time,
            date: state.date,
            isRepeat: state.isRepeat,
            dayOfWeeks: state.dayOfWeeks.join(','),
          );
      await _userRepository.saveSchedule(schedule);
      // action
      final initialActionView = {
        for (final ac in state.initialActions) ac.id: ac
      };
      // handle new actions
      final newAction = state.actions
          .where((ac) => !initialActionView.containsKey(ac.id))
          .toList();
      for (final ac in newAction) {
        await _userRepository.saveAction(ac);
      }
      // handle editted actions
      final edittedActions = state.actions
          .where((ac) => initialActionView.containsKey(ac.id))
          .toList();
      for (final ac in edittedActions) {
        await _userRepository.saveAction(ac);
      }
      // handle deleted action
      final deletedActions = state.initialActions
          .where((ac) => !state.actionView.containsKey(ac.id))
          .toList();
      for (final ac in deletedActions) {
        await _userRepository.deleteAction(ac.id);
      }
      emit(state.copyWith(status: EditScheduleStatus.success));
    } catch (error) {
      final err = error.toString().split(':').last.trim();
      emit(
        state.copyWith(
          status: EditScheduleStatus.failure,
          error: () => err,
        ),
      );
      emit(
        state.copyWith(
          status: EditScheduleStatus.normal,
          error: () => null,
        ),
      );
    }
  }
}
