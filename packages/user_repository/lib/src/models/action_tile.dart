import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:user_repository/src/models/typedef.dart';
import 'package:uuid/uuid.dart';

part 'generated/action_tile.g.dart';

@immutable
@JsonSerializable()

/// ActionTile model for an API providing to access condition
class ActionTile extends Equatable {
  /// {macro ActionTile}
  ActionTile({
    FieldId? id,
    required this.tileID,
    required this.actionID,
    required this.sequence,
  })  : assert(
          id == null || id.isNotEmpty,
          'id can not be null and should be empty',
        ),
        id = id ?? const Uuid().v4();

  /// The ID
  final FieldId id;

  /// The alert ID
  @JsonKey(name: 'tile_id')
  final FieldId tileID;

  /// The attribute ID
  @JsonKey(name: 'action_id')
  final FieldId actionID;

  /// The name of condition
  final int sequence;

  /// Deserializes the given [JsonMap] into a [ActionTile].
  static ActionTile fromJson(JsonMap json) {
    return _$ActionTileFromJson(json);
  }

  /// Converts this [ActionTile] into a [JsonMap].
  JsonMap toJson() => _$ActionTileToJson(this);

  /// Returns a copy of [ActionTile] with given parameters
  ActionTile copyWith({
    FieldId? id,
    FieldId? tileID,
    FieldId? actionID,
    int? sequence,
  }) {
    return ActionTile(
      id: id ?? this.id,
      tileID: tileID ?? this.tileID,
      actionID: actionID ?? this.actionID,
      sequence: sequence ?? this.sequence,
    );
  }

  @override
  List<Object?> get props => [id, tileID, actionID, sequence];
}
