// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../condition_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConditionLog _$ConditionLogFromJson(Map<String, dynamic> json) => ConditionLog(
      id: json['id'] as String?,
      alertLogID: json['alert_log_id'] as String,
      conditionID: json['condition_id'] as String,
      value: json['value'] as String,
    );

Map<String, dynamic> _$ConditionLogToJson(ConditionLog instance) =>
    <String, dynamic>{
      'id': instance.id,
      'alert_log_id': instance.alertLogID,
      'condition_id': instance.conditionID,
      'value': instance.value,
    };
