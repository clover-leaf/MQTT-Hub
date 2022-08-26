// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../condition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Condition _$ConditionFromJson(Map<String, dynamic> json) => Condition(
      id: json['id'] as String?,
      alertID: json['alert_id'] as String,
      attributeID: json['attribute_id'] as String,
      comparation: $enumDecode(_$ComparationEnumMap, json['comparation']),
      value: json['value'] as String,
    );

Map<String, dynamic> _$ConditionToJson(Condition instance) => <String, dynamic>{
      'id': instance.id,
      'alert_id': instance.alertID,
      'attribute_id': instance.attributeID,
      'comparation': _$ComparationEnumMap[instance.comparation]!,
      'value': instance.value,
    };

const _$ComparationEnumMap = {
  Comparation.geq: 'geq',
  Comparation.g: 'g',
  Comparation.eq: 'eq',
  Comparation.l: 'l',
  Comparation.leq: 'leq',
};
