part of 'edit_tile_bloc.dart';

enum EditTileStatus {
  normal,
  processing,
  success,
  failure,
}

extension EditTileStatusX on EditTileStatus {
  bool isProcessing() => this == EditTileStatus.processing;
  bool isSuccess() => this == EditTileStatus.success;
  bool isFailure() => this == EditTileStatus.failure;
}

class EditTileState extends Equatable {
  EditTileState({
    this.status = EditTileStatus.normal,
    required this.dashboardID,
    required this.devices,
    required this.attributes,
    required this.type,
    required this.lob,
    required this.color,
    required this.icon,
    this.tileName = '',
    this.selectedAttributeID,
    this.selectedDeviceID,
    this.initialTile,
    this.error,
  });

  // immutate
  final FieldId dashboardID;
  final List<Device> devices;
  final List<Attribute> attributes;
  final TileType type;

  // choose
  final FieldId? selectedDeviceID;
  final FieldId? selectedAttributeID;
  final String color;
  final String icon;

  // input
  final String tileName;
  final String lob;

  // status
  final EditTileStatus status;
  final String? error;

  // initial
  final Tile? initialTile;

  late final Map<FieldId, Device> deviceView = {
    for (final dv in devices) dv.id: dv
  };

  List<Attribute> get showedAttributes =>
      attributes.where((att) => att.deviceID == selectedDeviceID).toList();

  Map<FieldId, Attribute> get attributeView =>
      {for (final att in attributes) att.id: att};

  @override
  List<Object?> get props => [
        dashboardID,
        selectedDeviceID,
        selectedAttributeID,
        tileName,
        color,
        icon,
        type,
        lob,
        devices,
        attributes,
        status,
        initialTile,
        error,
      ];

  EditTileState copyWith({
    FieldId? dashboardID,
    List<Device>? devices,
    List<Attribute>? attributes,
    FieldId? selectedDeviceID,
    FieldId? selectedAttributeID,
    String? color,
    String? icon,
    TileType? type,
    String? tileName,
    String? lob,
    EditTileStatus? status,
    Tile? initialTile,
    String? Function()? error,
  }) {
    return EditTileState(
      dashboardID: dashboardID ?? this.dashboardID,
      devices: devices ?? this.devices,
      attributes: attributes ?? this.attributes,
      selectedDeviceID: selectedDeviceID ?? this.selectedDeviceID,
      selectedAttributeID: selectedAttributeID ?? this.selectedAttributeID,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      type: type ?? this.type,
      tileName: tileName ?? this.tileName,
      lob: lob ?? this.lob,
      status: status ?? this.status,
      initialTile: initialTile ?? this.initialTile,
      error: error != null ? error() : this.error,
    );
  }
}
