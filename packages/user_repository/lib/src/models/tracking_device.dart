import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:user_repository/src/models/typedef.dart';
import 'package:uuid/uuid.dart';

part 'generated/tracking_device.g.dart';

@immutable
@JsonSerializable()

/// TrackingDevice model for an API providing to access tracking_device
class TrackingDevice extends Equatable {
  /// {macro TrackingDevice}
  TrackingDevice({
    FieldId? id,
    required this.deviceID,
    required this.time,
  })  : assert(
          id == null || id.isNotEmpty,
          'id can not be null and should be empty',
        ),
        id = id ?? const Uuid().v4();

  /// The ID
  final FieldId id;

  /// The alert ID
  @JsonKey(name: 'device_id')
  final FieldId deviceID;

  /// The alert ID
  final DateTime time;

  /// Deserializes the given [JsonMap] into a [TrackingDevice].
  static TrackingDevice fromJson(JsonMap json) {
    return _$TrackingDeviceFromJson(json);
  }

  /// Converts this [TrackingDevice] into a [JsonMap].
  JsonMap toJson() => _$TrackingDeviceToJson(this);

  /// Returns a copy of [TrackingDevice] with given parameters
  TrackingDevice copyWith({
    FieldId? id,
    FieldId? deviceID,
    DateTime? time,
  }) {
    return TrackingDevice(
      id: id ?? this.id,
      deviceID: deviceID ?? this.deviceID,
      time: time ?? this.time,
    );
  }

  @override
  List<Object?> get props => [id, deviceID, time];
}
