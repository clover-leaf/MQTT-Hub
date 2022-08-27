// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../condition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Condition _$ConditionFromJson(Map<String, dynamic> json) => Condition(
      id: json['id'] as String?,
      alertID: json['alert_id'] as String,
      attributeID: json['attribute_id'] as String,
      comparison: $enumDecode(_$ComparisonEnumMap, json['comparison']),
      value: json['value'] as String,
    );

Map<String, dynamic> _$ConditionToJson(Condition instance) => <String, dynamic>{
      'id': instance.id,
      'alert_id': instance.alertID,
      'attribute_id': instance.attributeID,
      'comparison': _$ComparisonEnumMap[instance.comparison]!,
      'value': instance.value,
    };

const _$ComparisonEnumMap = {
  Comparison.geq: 'geq',
  Comparison.g: 'g',
  Comparison.eq: 'eq',
  Comparison.l: 'l',
  Comparison.leq: 'leq',
};
