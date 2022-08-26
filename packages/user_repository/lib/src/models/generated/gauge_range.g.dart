// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../gauge_range.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GaugeRange _$GaugeRangeFromJson(Map<String, dynamic> json) => GaugeRange(
      color: json['color'] as String,
      min: json['min'] as String?,
      max: json['max'] as String?,
    );

Map<String, dynamic> _$GaugeRangeToJson(GaugeRange instance) =>
    <String, dynamic>{
      'min': instance.min,
      'max': instance.max,
      'color': instance.color,
    };
