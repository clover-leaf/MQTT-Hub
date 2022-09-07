// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../device_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceType _$DeviceTypeFromJson(Map<String, dynamic> json) => DeviceType(
      id: json['id'] as String?,
      projectID: json['project_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$DeviceTypeToJson(DeviceType instance) =>
    <String, dynamic>{
      'id': instance.id,
      'project_id': instance.projectID,
      'name': instance.name,
      'description': instance.description,
    };
