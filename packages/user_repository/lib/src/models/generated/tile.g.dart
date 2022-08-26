// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../tile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tile _$TileFromJson(Map<String, dynamic> json) => Tile(
      id: json['id'] as String?,
      dashboardID: json['dashboard_id'] as String,
      deviceID: json['device_id'] as String,
      attributeID: json['attribute_id'] as String,
      name: json['name'] as String,
      type: $enumDecode(_$TileTypeEnumMap, json['type']),
      lob: json['lob'] as String,
      color: json['color'] as String,
      icon: json['icon'] as String,
    );

Map<String, dynamic> _$TileToJson(Tile instance) => <String, dynamic>{
      'id': instance.id,
      'dashboard_id': instance.dashboardID,
      'device_id': instance.deviceID,
      'attribute_id': instance.attributeID,
      'name': instance.name,
      'type': _$TileTypeEnumMap[instance.type]!,
      'lob': instance.lob,
      'color': instance.color,
      'icon': instance.icon,
    };

const _$TileTypeEnumMap = {
  TileType.text: 'text',
  TileType.radialGauge: 'radialGauge',
  TileType.linearGauge: 'linearGauge',
  TileType.toggle: 'toggle',
  TileType.multiCommand: 'multiCommand',
};
