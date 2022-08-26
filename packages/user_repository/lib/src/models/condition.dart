import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:user_repository/src/models/comparation.dart';
import 'package:user_repository/src/models/typedef.dart';
import 'package:uuid/uuid.dart';

part 'generated/condition.g.dart';

@immutable
@JsonSerializable()

/// Condition model for an API providing to access condition
class Condition extends Equatable {
  /// {macro Condition}
  Condition({
    FieldId? id,
    required this.alertID,
    required this.attributeID,
    required this.comparation,
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
  @JsonKey(name: 'attribute_id')
  final FieldId attributeID;

  /// The name of condition
  final Comparation comparation;

  /// The value
  final String value;

  /// Deserializes the given [JsonMap] into a [Condition].
  static Condition fromJson(JsonMap json) {
    return _$ConditionFromJson(json);
  }

  /// Converts this [Condition] into a [JsonMap].
  JsonMap toJson() => _$ConditionToJson(this);

  /// Returns a copy of [Condition] with given parameters
  Condition copyWith({
    FieldId? id,
    FieldId? alertID,
    FieldId? attributeID,
    Comparation? comparation,
    String? value,
  }) {
    return Condition(
      id: id ?? this.id,
      alertID: alertID ?? this.alertID,
      attributeID: attributeID ?? this.attributeID,
      comparation: comparation ?? this.comparation,
      value: value ?? this.value,
    );
  }

  @override
  List<Object?> get props => [id, alertID, attributeID, comparation, value];
}
