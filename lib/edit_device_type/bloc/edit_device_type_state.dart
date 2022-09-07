part of 'edit_device_type_bloc.dart';

enum EditDeviceTypeStatus {
  normal,
  processing,
  success,
  failure,
}

extension EditDeviceTypeStatusX on EditDeviceTypeStatus {
  bool isProcessing() => this == EditDeviceTypeStatus.processing;
  bool isSuccess() => this == EditDeviceTypeStatus.success;
  bool isFailure() => this == EditDeviceTypeStatus.failure;
}

class EditDeviceTypeState extends Equatable {
  const EditDeviceTypeState({
    this.status = EditDeviceTypeStatus.normal,
    required this.id,
    required this.isEdit,
    required this.isAdmin,
    required this.parentProjectID,
    required this.initialAttributes,
    required this.attributes,
    this.name = '',
    this.description,
    this.initialDeviceType,
    this.error,
  });

  // immutate
  final String id;
  final String parentProjectID;
  final List<Attribute> initialAttributes;

  // input
  final String name;
  final String? description;
  final List<Attribute> attributes;

  // status
  final EditDeviceTypeStatus status;
  final bool isEdit;
  final bool isAdmin;
  final String? error;

  // initial
  final DeviceType? initialDeviceType;

  @override
  List<Object?> get props => [
        id,
        parentProjectID,
        initialAttributes,
        attributes,
        name,
        description,
        initialDeviceType,
        status,
        isEdit,
        isAdmin,
        error
      ];

  EditDeviceTypeState copyWith({
    String? id,
    String? parentProjectID,
    List<Attribute>? initialAttributes,
    List<Attribute>? attributes,
    String? name,
    String? description,
    EditDeviceTypeStatus? status,
    DeviceType? initialDeviceType,
    bool? isEdit,
    bool? isAdmin,
    String? Function()? error,
  }) {
    return EditDeviceTypeState(
      isEdit: isEdit ?? this.isEdit,
      isAdmin: isAdmin ?? this.isAdmin,
      id: id ?? this.id,
      parentProjectID: parentProjectID ?? this.parentProjectID,
      initialAttributes: initialAttributes ?? this.initialAttributes,
      attributes: attributes ?? this.attributes,
      name: name ?? this.name,
      description: description ?? this.description,
      status: status ?? this.status,
      initialDeviceType: initialDeviceType ?? this.initialDeviceType,
      error: error != null ? error() : this.error,
    );
  }
}
