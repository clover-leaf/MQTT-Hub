import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:user_repository/user_repository.dart';
import 'package:uuid/uuid.dart';

part 'generated/tile.g.dart';

@immutable
@JsonSerializable()

/// Tile model for an API providing to access tile
class Tile extends Equatable {
  /// {macro Tile}
  Tile({
    FieldId? id,
    required this.dashboardID,
    required this.deviceID,
    required this.attributeID,
    required this.name,
    required this.type,
    required this.lob,
    required this.color,
    required this.icon,
  })  : assert(
          id == null || id.isNotEmpty,
          'id can not be null and should be empty',
        ),
        id = id ?? const Uuid().v4();

  /// The ID
  final FieldId id;

  /// The dashboard ID
  @JsonKey(name: 'dashboard_id')
  final FieldId dashboardID;

  /// The device ID
  @JsonKey(name: 'device_id')
  final FieldId deviceID;

  /// The attribute ID
  @JsonKey(name: 'attribute_id')
  final FieldId attributeID;

  /// The name of tile
  final String name;

  /// The type of tile
  final TileType type;

  /// The lob of tile
  final String lob;

  /// The color of tile
  final String color;
  
  /// The icon of tile
  final String icon;

  /// Deserializes the given [JsonMap] into a [Tile].
  static Tile fromJson(JsonMap json) {
    return _$TileFromJson(json);
  }

  /// Converts this [Tile] into a [JsonMap].
  JsonMap toJson() => _$TileToJson(this);

  /// Returns a copy of [Tile] with given parameters
  Tile copyWith({
    FieldId? id,
    FieldId? dashboardID,
    FieldId? deviceID,
    FieldId? attributeID,
    String? name,
    TileType? type,
    String? lob,
    String? color,
    String? icon,
  }) {
    return Tile(
      id: id ?? this.id,
      dashboardID: dashboardID ?? this.dashboardID,
      deviceID: deviceID ?? this.deviceID,
      attributeID: attributeID ?? this.attributeID,
      name: name ?? this.name,
      type: type ?? this.type,
      lob: lob ?? this.lob,
      color: color ?? this.color,
      icon: icon ?? this.icon,
    );
  }

  @override
  List<Object?> get props =>
      [id, dashboardID, deviceID, attributeID, name, type, lob, color, icon];
}
