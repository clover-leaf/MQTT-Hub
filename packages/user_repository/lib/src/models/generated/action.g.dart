// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TAction _$TActionFromJson(Map<String, dynamic> json) => TAction(
      id: json['id'] as String?,
      alertID: json['alert_id'] as String?,
      scheduleID: json['schedule_id'] as String?,
      deviceID: json['device_id'] as String,
      attributeID: json['attribute_id'] as String,
      value: json['value'] as String,
    );

Map<String, dynamic> _$TActionToJson(TAction instance) => <String, dynamic>{
      'id': instance.id,
      'alert_id': instance.alertID,
      'schedule_id': instance.scheduleID,
      'device_id': instance.deviceID,
      'attribute_id': instance.attributeID,
      'value': instance.value,
    };
