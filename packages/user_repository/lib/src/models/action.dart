import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:user_repository/src/models/typedef.dart';
import 'package:uuid/uuid.dart';

part 'generated/action.g.dart';

@immutable
@JsonSerializable()

/// Action model for an API providing to access condition
class Action extends Equatable {
  /// {macro Action}
  Action({
    FieldId? id,
    required this.alertID,
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
  final FieldId alertID;

  /// The attribute ID
  @JsonKey(name: 'device_id')
  final FieldId deviceID;

  /// The attribute ID
  @JsonKey(name: 'attribute_id')
  final FieldId attributeID;

  /// The name of condition
  final String value;

  /// Deserializes the given [JsonMap] into a [Action].
  static Action fromJson(JsonMap json) {
    return _$ActionFromJson(json);
  }

  /// Converts this [Action] into a [JsonMap].
  JsonMap toJson() => _$ActionToJson(this);

  /// Returns a copy of [Action] with given parameters
  Action copyWith(
      {FieldId? id,
      FieldId? alertID,
      FieldId? deviceID,
      FieldId? attributeID,
      String? value,}) {
    return Action(
      id: id ?? this.id,
      alertID: alertID ?? this.alertID,
      deviceID: deviceID ?? this.deviceID,
      attributeID: attributeID ?? this.attributeID,
      value: value ?? this.value,
    );
  }

  @override
  List<Object?> get props => [id, alertID, deviceID, attributeID, value];
}
