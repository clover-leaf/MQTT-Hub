// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Device _$DeviceFromJson(Map<String, dynamic> json) => Device(
      id: json['id'] as String?,
      groupID: json['group_id'] as String,
      brokerID: json['broker_id'] as String,
      deviceTypeID: json['device_type_id'] as String?,
      name: json['name'] as String,
      description: json['description'] as String?,
      topic: json['topic'] as String,
      qos: json['qos'] as int,
    );

Map<String, dynamic> _$DeviceToJson(Device instance) => <String, dynamic>{
      'id': instance.id,
      'group_id': instance.groupID,
      'broker_id': instance.brokerID,
      'device_type_id': instance.deviceTypeID,
      'name': instance.name,
      'description': instance.description,
      'topic': instance.topic,
      'qos': instance.qos,
    };
