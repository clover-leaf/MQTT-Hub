import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:user_repository/src/models/typedef.dart';
import 'package:uuid/uuid.dart';

part 'generated/action.g.dart';

@immutable
@JsonSerializable()

/// TAction model for an API providing to access condition
class TAction extends Equatable {
  /// {macro TAction}
  TAction({
    FieldId? id,
    required this.alertID,
    required this.scheduleID,
    required this.deviceID,
    required this.attributeID,
    required this.value,
  })  : assert(
          id == null || id.isNotEmpty,
          'id can not be null and should be empty',
        ),
        id = id ?? const Uuid().v4();

  /// The ID
  final FieldId id;

  /// The alert ID
  @JsonKey(name: 'alert_id')
  final FieldId? alertID;

  /// The alert ID
  @JsonKey(name: 'schedule_id')
  final FieldId? scheduleID;

  /// The attribute ID
  @JsonKey(name: 'device_id')
  final FieldId deviceID;

  /// The attribute ID
  @JsonKey(name: 'attribute_id')
  final FieldId attributeID;

  /// The name of condition
  final String value;

  /// Deserializes the given [JsonMap] into a [TAction].
  static TAction fromJson(JsonMap json) {
    return _$TActionFromJson(json);
  }

  /// Converts this [TAction] into a [JsonMap].
  JsonMap toJson() => _$TActionToJson(this);

  /// Returns a copy of [TAction] with given parameters
  TAction copyWith({
    FieldId? id,
    FieldId? alertID,
    FieldId? scheduleID,
    FieldId? deviceID,
    FieldId? attributeID,
    String? value,
  }) {
    return TAction(
      id: id ?? this.id,
      alertID: alertID ?? this.alertID,
      scheduleID: scheduleID ?? this.scheduleID,
      deviceID: deviceID ?? this.deviceID,
      attributeID: attributeID ?? this.attributeID,
      value: value ?? this.value,
    );
  }

  @override
  List<Object?> get props =>
      [id, alertID, scheduleID, deviceID, attributeID, value];
}
