part of 'edit_alert_bloc.dart';

enum EditAlertStatus {
  normal,
  processing,
  success,
  failure,
}

extension EditAlertStatusX on EditAlertStatus {
  bool isProcessing() => this == EditAlertStatus.processing;
  bool isSuccess() => this == EditAlertStatus.success;
  bool isFailure() => this == EditAlertStatus.failure;
}

class EditAlertState extends Equatable {
  const EditAlertState({
    this.status = EditAlertStatus.normal,
    required this.isEdit,
    required this.isAdmin,
    required this.id,
    required this.devices,
    required this.attributes,
    required this.initialConditions,
    required this.conditions,
    required this.initialActions,
    required this.actions,
    this.name = '',
    this.selectedDeviceID,
    this.initialAlert,
    this.error,
  });

  // immutate
  final String id;
  final List<Device> devices;
  final List<Attribute> attributes;
  final List<Condition> initialConditions;
  final List<TAction> initialActions;

  // choose
  final String? selectedDeviceID;

  // input
  final String name;
  final List<Condition> conditions;
  final List<TAction> actions;

  // status
  final EditAlertStatus status;
  final bool isEdit;
  final bool isAdmin;
  final String? error;

  // initial
  final Alert? initialAlert;

  Map<String, Condition> get conditionView =>
      {for (final cd in conditions) cd.id: cd};

  Map<String, TAction> get actionView => {for (final ac in actions) ac.id: ac};

  List<Attribute> get attributeOfSelectedDevice =>
      attributes.where((att) => att.deviceID == selectedDeviceID).toList();

  @override
  List<Object?> get props => [
        id,
        isAdmin,
        isEdit,
        devices,
        initialConditions,
        initialActions,
        attributes,
        selectedDeviceID,
        name,
        conditions,
        actions,
        initialAlert,
        status,
        error
      ];

  EditAlertState copyWith({
    String? id,
    List<Device>? devices,
    List<Attribute>? attributes,
    List<Condition>? initialConditions,
    List<TAction>? initialActions,
    String? selectedDeviceID,
    String? name,
    List<Condition>? conditions,
    List<TAction>? actions,
    EditAlertStatus? status,
    Alert? initialAlert,
    bool? isEdit,
    bool? isAdmin,
    String? Function()? error,
  }) {
    return EditAlertState(
      id: id ?? this.id,
      isEdit: isEdit ?? this.isEdit,
      isAdmin: isAdmin ?? this.isAdmin,
      devices: devices ?? this.devices,
      attributes: attributes ?? this.attributes,
      initialConditions: initialConditions ?? this.initialConditions,
      initialActions: initialActions ?? this.initialActions,
      selectedDeviceID: selectedDeviceID ?? this.selectedDeviceID,
      name: name ?? this.name,
      conditions: conditions ?? this.conditions,
      actions: actions ?? this.actions,
      status: status ?? this.status,
      initialAlert: initialAlert ?? this.initialAlert,
      error: error != null ? error() : this.error,
    );
  }
}
