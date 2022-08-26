// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../toggle_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ToggleConfig _$ToggleConfigFromJson(Map<String, dynamic> json) => ToggleConfig(
      value: json['value'] as String,
      color: json['color'] as String,
      label: json['label'] as String?,
    );

Map<String, dynamic> _$ToggleConfigToJson(ToggleConfig instance) =>
    <String, dynamic>{
      'value': instance.value,
      'label': instance.label,
      'color': instance.color,
    };
