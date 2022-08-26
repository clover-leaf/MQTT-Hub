import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:user_repository/src/models/typedef.dart';
import 'package:uuid/uuid.dart';

part 'generated/device.g.dart';

@immutable
@JsonSerializable()

/// Device model for an API providing to access device
class Device extends Equatable {
  /// {macro Device}
  Device({
    FieldId? id,
    required this.groupID,
    required this.brokerID,
    required this.name,
    required this.topic,
  })  : assert(
          id == null || id.isNotEmpty,
          'id can not be null and should be empty',
        ),
        id = id ?? const Uuid().v4();

  /// The ID
  final FieldId id;

  /// The parent group ID
  @JsonKey(name: 'group_id')
  final FieldId groupID;

  /// The broker ID
  @JsonKey(name: 'broker_id')
  final FieldId brokerID;

  /// The name of device
  final String name;

  /// The topic of device
  final String topic;

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
    FieldId? brokerID,
    String? name,
    String? topic,
  }) {
    return Device(
      id: id ?? this.id,
      groupID: groupID ?? this.groupID,
      brokerID: brokerID ?? this.brokerID,
      name: name ?? this.name,
      topic: topic ?? this.topic,
    );
  }

  @override
  List<Object> get props => [id, groupID, brokerID, name, topic];
}
