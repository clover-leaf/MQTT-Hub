part of 'edit_tile_bloc.dart';

class EditTileEvent extends Equatable {
  const EditTileEvent();

  @override
  List<Object?> get props => [];
}

class Submitted extends EditTileEvent {
  const Submitted();
}

class TileNameChanged extends EditTileEvent {
  const TileNameChanged(this.tileName);

  final String tileName;

  @override
  List<Object> get props => [tileName];
}

class DeviceIDChanged extends EditTileEvent {
  const DeviceIDChanged(this.deviceID);

  final FieldId deviceID;

  @override
  List<Object> get props => [deviceID];
}

class AttributeIDChanged extends EditTileEvent {
  const AttributeIDChanged(this.attributeID);

  final FieldId attributeID;

  @override
  List<Object> get props => [attributeID];
}

class LobChanged extends EditTileEvent {
  const LobChanged(this.lob);

  final String lob;

  @override
  List<Object> get props => [lob];
}


class ColorChanged extends EditTileEvent {
  const ColorChanged(this.color);

  final String color;

  @override
  List<Object> get props => [color];
}


class IconChanged extends EditTileEvent {
  const IconChanged(this.icon);

  final String icon;

  @override
  List<Object> get props => [icon];
}
