// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../dashboard.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Dashboard _$DashboardFromJson(Map<String, dynamic> json) => Dashboard(
      id: json['id'] as String?,
      projectID: json['project_id'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$DashboardToJson(Dashboard instance) => <String, dynamic>{
      'id': instance.id,
      'project_id': instance.projectID,
      'name': instance.name,
    };
