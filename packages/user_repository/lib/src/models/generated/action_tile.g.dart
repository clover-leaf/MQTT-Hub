// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../action_tile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActionTile _$ActionTileFromJson(Map<String, dynamic> json) => ActionTile(
      id: json['id'] as String?,
      tileID: json['tile_id'] as String,
      actionID: json['action_id'] as String,
      sequence: json['sequence'] as int,
    );

Map<String, dynamic> _$ActionTileToJson(ActionTile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tile_id': instance.tileID,
      'action_id': instance.actionID,
      'sequence': instance.sequence,
    };
