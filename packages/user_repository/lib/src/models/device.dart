import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:user_repository/src/models/typedef.dart';
import 'package:uuid/uuid.dart';

part 'device.g.dart';

@immutable
@JsonSerializable()

/// Device model for an API providing to access device
class Device extends Equatable {
  /// {macro Device}
  Device({
    FieldId? id,
    required this.groupID,
    required this.name,
  })  : assert(
          id == null || id.isNotEmpty,
          'id can not be null and should be empty',
        ),
        id = id ?? const Uuid().v4();

  /// The group ID
  final FieldId id;

  /// The parent group ID
  @JsonKey(name: 'group_id')
  final FieldId groupID;

  /// The name of project
  final String name;

  /// Deserializes the given [JsonMap] into a [Device].
  static Device fromJson(JsonMap json) {
    return _$DeviceFromJson(json);
  }

  /// Converts this [Device] into a [JsonMap].
  JsonMap toJson() => _$DeviceToJson(this);

  /// Returns a copy of [Device] with given parameters
  Device copyWith({
    FieldId? id,
    FieldId? groupID,
    String? name,
  }) {
    return Device(
      id: id ?? this.id,
      groupID: groupID ?? this.groupID,
      name: name ?? this.name,
    );
  }

  @override
  List<Object> get props => [id, groupID, name];
}
