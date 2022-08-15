import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:user_repository/src/models/typedef.dart';
import 'package:uuid/uuid.dart';

part 'attribute.g.dart';

@immutable
@JsonSerializable()

/// Attribute model for an API providing to access attribute
class Attribute extends Equatable {
  /// {macro Attribute}
  Attribute({
    FieldId? id,
    required this.deviceID,
    required this.name,
    required this.jsonPath,
  })  : assert(
          id == null || id.isNotEmpty,
          'id can not be null and should be empty',
        ),
        id = id ?? const Uuid().v4();

  /// The ID
  final FieldId id;

  /// The device ID
  @JsonKey(name: 'device_id')
  final FieldId deviceID;

  /// The name of attribute
  final String name;

  /// The json paht of attribute
  @JsonKey(name: 'json_path')
  final String jsonPath;

  /// Deserializes the given [JsonMap] into a [Attribute].
  static Attribute fromJson(JsonMap json) {
    return _$AttributeFromJson(json);
  }

  /// Converts this [Attribute] into a [JsonMap].
  JsonMap toJson() => _$AttributeToJson(this);

  /// Returns a copy of [Attribute] with given parameters
  Attribute copyWith({
    FieldId? id,
    FieldId? deviceID,
    String? name,
    String? jsonPath,
  }) {
    return Attribute(
      id: id ?? this.id,
      deviceID: deviceID ?? this.deviceID,
      name: name ?? this.name,
      jsonPath: jsonPath ?? this.jsonPath,
    );
  }

  @override
  List<Object?> get props => [id, deviceID, name, jsonPath];
}
