// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../schedule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Schedule _$ScheduleFromJson(Map<String, dynamic> json) => Schedule(
      id: json['id'] as String?,
      projectID: json['project_id'] as String,
      name: json['name'] as String,
      time: DateTime.parse(json['time'] as String),
      date: DateTime.parse(json['date'] as String),
      dayOfWeeks: json['day_of_weeks'] as String,
      isRepeat: json['is_repeat'] as bool,
    );

Map<String, dynamic> _$ScheduleToJson(Schedule instance) => <String, dynamic>{
      'id': instance.id,
      'project_id': instance.projectID,
      'name': instance.name,
      'time': instance.time.toIso8601String(),
      'date': instance.date.toIso8601String(),
      'day_of_weeks': instance.dayOfWeeks,
      'is_repeat': instance.isRepeat,
    };
