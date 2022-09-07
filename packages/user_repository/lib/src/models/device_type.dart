import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:user_repository/src/models/typedef.dart';
import 'package:uuid/uuid.dart';

part 'generated/device_type.g.dart';

@immutable
@JsonSerializable()

/// DeviceType model for an API providing to access device
class DeviceType extends Equatable {
  /// {macro DeviceType}
  DeviceType({
    FieldId? id,
    required this.projectID,
    required this.name,
    required this.description,
  })  : assert(
          id == null || id.isNotEmpty,
          'id can not be null and should be empty',
        ),
        id = id ?? const Uuid().v4();

  /// The ID
  final FieldId id;

  /// The broker ID
  @JsonKey(name: 'project_id')
  final FieldId projectID;

  /// The name of device
  final String name;
  
  /// The name of device
  final String? description;

  /// Deserializes the given [JsonMap] into a [DeviceType].
  static DeviceType fromJson(JsonMap json) {
    return _$DeviceTypeFromJson(json);
  }

  /// Converts this [DeviceType] into a [JsonMap].
  JsonMap toJson() => _$DeviceTypeToJson(this);

  /// Returns a copy of [DeviceType] with given parameters
  DeviceType copyWith({
    FieldId? id,
    FieldId? projectID,
    String? name,
    String? description,
  }) {
    return DeviceType(
      id: id ?? this.id,
      projectID: projectID ?? this.projectID,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props => [id, projectID, name, description];
}
