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
    required this.deviceTypeID,
    required this.name,
    required this.description,
    required this.topic,
    required this.qos,
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

  /// The broker ID
  @JsonKey(name: 'device_type_id')
  final FieldId? deviceTypeID;

  /// The name of device
  final String name;

  /// The name of device
  final String? description;

  /// The topic of device
  final String topic;

  /// The QoS of device
  final int qos;

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
    FieldId? deviceTypeID,
    String? name,
    String? description,
    String? topic,
    int? qos,
  }) {
    return Device(
      id: id ?? this.id,
      groupID: groupID ?? this.groupID,
      brokerID: brokerID ?? this.brokerID,
      deviceTypeID: deviceTypeID ?? this.deviceTypeID,
      name: name ?? this.name,
      description: description ?? this.description,
      topic: topic ?? this.topic,
      qos: qos ?? this.qos,
    );
  }

  @override
  List<Object?> get props =>
      [id, groupID, brokerID, deviceTypeID, name, description, topic, qos];
}
