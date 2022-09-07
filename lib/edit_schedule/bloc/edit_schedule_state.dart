part of 'edit_schedule_bloc.dart';

enum EditScheduleStatus {
  normal,
  processing,
  success,
  failure,
}

extension EditScheduleStatusX on EditScheduleStatus {
  bool isProcessing() => this == EditScheduleStatus.processing;
  bool isSuccess() => this == EditScheduleStatus.success;
  bool isFailure() => this == EditScheduleStatus.failure;
}

class EditScheduleState extends Equatable {
  const EditScheduleState({
    this.status = EditScheduleStatus.normal,
    required this.id,
    required this.parentProject,
    required this.isEdit,
    required this.isAdmin,
    required this.name,
    required this.time,
    required this.date,
    required this.isRepeat,
    required this.dayOfWeeks,
    required this.devices,
    required this.attributes,
    required this.initialActions,
    required this.actions,
    this.initialSchedule,
    this.error,
  });

  // immutate
  final String id;
  final Project parentProject;
  final List<Device> devices;
  final List<Attribute> attributes;
  final List<TAction> initialActions;

  // input
  final String name;
  final DateTime time;
  final DateTime date;
  final bool isRepeat;
  final List<int> dayOfWeeks;
  final List<TAction> actions;

  // initial
  final Schedule? initialSchedule;

  // status
  final EditScheduleStatus status;
  final bool isEdit;
  final bool isAdmin;
  final String? error;

  Map<String, TAction> get actionView => {for (final ac in actions) ac.id: ac};

  @override
  List<Object?> get props => [
        id,
        parentProject,
        initialSchedule,
        devices,
        attributes,
        initialActions,
        name,
        time,
        date,
        isRepeat,
        dayOfWeeks,
        actions,
        status,
        isAdmin,
        isEdit,
        error
      ];

  EditScheduleState copyWith({
    String? id,
    EditScheduleStatus? status,
    Project? parentProject,
    Schedule? initialSchedule,
    List<Device>? devices,
    List<Attribute>? attributes,
    List<TAction>? initialActions,
    String? name,
    DateTime? time,
    DateTime? date,
    bool? isRepeat,
    List<int>? dayOfWeeks,
    List<TAction>? actions,
    bool? isEdit,
    bool? isAdmin,
    String? Function()? error,
  }) {
    return EditScheduleState(
      id: id ?? this.id,
      isEdit: isEdit ?? this.isEdit,
      isAdmin: isAdmin ?? this.isAdmin,
      status: status ?? this.status,
      parentProject: parentProject ?? this.parentProject,
      initialSchedule: initialSchedule ?? this.initialSchedule,
      devices: devices ?? this.devices,
      attributes: attributes ?? this.attributes,
      initialActions: initialActions ?? this.initialActions,
      name: name ?? this.name,
      time: time ?? this.time,
      date: date ?? this.date,
      isRepeat: isRepeat ?? this.isRepeat,
      dayOfWeeks: dayOfWeeks ?? this.dayOfWeeks,
      actions: actions ?? this.actions,
      error: error != null ? error() : this.error,
    );
  }
}
