import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:user_repository/src/models/typedef.dart';
import 'package:uuid/uuid.dart';

part 'generated/condition_log.g.dart';

@immutable
@JsonSerializable()

/// ConditionLog model for an API providing to access log
class ConditionLog extends Equatable {
  /// {macro ConditionLog}
  ConditionLog({
    FieldId? id,
    required this.alertLogID,
    required this.conditionID,
    required this.value,
  })  : assert(
          id == null || id.isNotEmpty,
          'id can not be null and should be empty',
        ),
        id = id ?? const Uuid().v4();

  /// The ID
  final FieldId id;

  /// The alert log ID
  @JsonKey(name: 'alert_log_id')
  final FieldId alertLogID;

  /// The condition ID
  @JsonKey(name: 'condition_id')
  final FieldId conditionID;

  /// The value
  final String value;

  /// Deserializes the given [JsonMap] into a [ConditionLog].
  static ConditionLog fromJson(JsonMap json) {
    return _$ConditionLogFromJson(json);
  }

  /// Converts this [ConditionLog] into a [JsonMap].
  JsonMap toJson() => _$ConditionLogToJson(this);

  /// Returns a copy of [ConditionLog] with given parameters
  ConditionLog copyWith({
    FieldId? id,
    FieldId? alertLogID,
    FieldId? conditionID,
    String? value,
  }) {
    return ConditionLog(
      id: id ?? this.id,
      alertLogID: alertLogID ?? this.alertLogID,
      conditionID: conditionID ?? this.conditionID,
      value: value ?? this.value,
    );
  }

  @override
  List<Object?> get props => [id, alertLogID, conditionID, value];
}
