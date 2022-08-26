// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Command _$CommandFromJson(Map<String, dynamic> json) => Command(
      icon: json['icon'] as String,
      label: json['label'] as String,
      value: json['value'] as String,
    );

Map<String, dynamic> _$CommandToJson(Command instance) => <String, dynamic>{
      'label': instance.label,
      'value': instance.value,
      'icon': instance.icon,
    };
