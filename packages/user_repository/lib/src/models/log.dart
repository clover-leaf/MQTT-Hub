import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:user_repository/src/models/typedef.dart';
import 'package:uuid/uuid.dart';

part 'generated/log.g.dart';

@immutable
@JsonSerializable()

/// Log model for an API providing to access log
class Log extends Equatable {
  /// {macro Log}
  Log({
    FieldId? id,
    required this.alertID,
    required this.time,
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

  /// The alert ID
  final DateTime time;

  /// Deserializes the given [JsonMap] into a [Log].
  static Log fromJson(JsonMap json) {
    return _$LogFromJson(json);
  }

  /// Converts this [Log] into a [JsonMap].
  JsonMap toJson() => _$LogToJson(this);

  /// Returns a copy of [Log] with given parameters
  Log copyWith({
    FieldId? id,
    FieldId? alertID,
    DateTime? time,
  }) {
    return Log(
      id: id ?? this.id,
      alertID: alertID ?? this.alertID,
      time: time ?? this.time,
    );
  }

  @override
  List<Object?> get props => [id, alertID, time];
}
