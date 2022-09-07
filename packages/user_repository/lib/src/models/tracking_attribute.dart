import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:user_repository/src/models/typedef.dart';
import 'package:uuid/uuid.dart';

part 'generated/tracking_attribute.g.dart';

@immutable
@JsonSerializable()

/// TrackingAttribute model for an API providing to access log
class TrackingAttribute extends Equatable {
  /// {macro TrackingAttribute}
  TrackingAttribute({
    FieldId? id,
    required this.trackingDeviceID,
    required this.attributeID,
    required this.value,
  })  : assert(
          id == null || id.isNotEmpty,
          'id can not be null and should be empty',
        ),
        id = id ?? const Uuid().v4();

  /// The ID
  final FieldId id;

  /// The alert log ID
  @JsonKey(name: 'tracking_device_id')
  final FieldId trackingDeviceID;

  /// The condition ID
  @JsonKey(name: 'attribute_id')
  final FieldId attributeID;

  /// The value
  final String value;

  /// Deserializes the given [JsonMap] into a [TrackingAttribute].
  static TrackingAttribute fromJson(JsonMap json) {
    return _$TrackingAttributeFromJson(json);
  }

  /// Converts this [TrackingAttribute] into a [JsonMap].
  JsonMap toJson() => _$TrackingAttributeToJson(this);

  /// Returns a copy of [TrackingAttribute] with given parameters
  TrackingAttribute copyWith({
    FieldId? id,
    FieldId? trackingDeviceID,
    FieldId? attributeID,
    String? value,
  }) {
    return TrackingAttribute(
      id: id ?? this.id,
      trackingDeviceID: trackingDeviceID ?? this.trackingDeviceID,
      attributeID: attributeID ?? this.attributeID,
      value: value ?? this.value,
    );
  }

  @override
  List<Object?> get props => [id, trackingDeviceID, attributeID, value];
}
