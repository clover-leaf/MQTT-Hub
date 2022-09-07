import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:user_repository/src/models/typedef.dart';
import 'package:uuid/uuid.dart';

part 'generated/schedule.g.dart';

@immutable
@JsonSerializable()

/// Schedule model for an API providing to access condition
class Schedule extends Equatable {
  /// {macro Schedule}
  Schedule({
    FieldId? id,
    required this.projectID,
    required this.name,
    required this.time,
    required this.date,
    required this.dayOfWeeks,
    required this.isRepeat,
  })  : assert(
          id == null || id.isNotEmpty,
          'id can not be null and should be empty',
        ),
        id = id ?? const Uuid().v4();

  /// The ID
  final FieldId id;

  /// The device ID
  @JsonKey(name: 'project_id')
  final FieldId projectID;

  /// The name of condition
  final String name;

  /// time of date
  final DateTime time;

  /// date
  final DateTime date;

  /// '0,1' => mon, tue, fri
  @JsonKey(name: 'day_of_weeks')
  final String dayOfWeeks;

  ///
  @JsonKey(name: 'is_repeat')
  final bool isRepeat;

  /// Deserializes the given [JsonMap] into a [Schedule].
  static Schedule fromJson(JsonMap json) {
    return _$ScheduleFromJson(json);
  }

  /// Converts this [Schedule] into a [JsonMap].
  JsonMap toJson() => _$ScheduleToJson(this);

  /// Returns a copy of [Schedule] with given parameters
  Schedule copyWith({
    FieldId? id,
    FieldId? projectID,
    String? name,
    DateTime? time,
    DateTime? date,
    String? dayOfWeeks,
    bool? isRepeat,
  }) {
    return Schedule(
      id: id ?? this.id,
      projectID: projectID ?? this.projectID,
      name: name ?? this.name,
      time: time ?? this.time,
      date: date ?? this.date,
      dayOfWeeks: dayOfWeeks ?? this.dayOfWeeks,
      isRepeat: isRepeat ?? this.isRepeat,
    );
  }

  @override
  List<Object?> get props =>
      [id, projectID, name, time, date, dayOfWeeks, isRepeat];
}
