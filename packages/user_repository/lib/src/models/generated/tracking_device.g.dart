// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../tracking_device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrackingDevice _$TrackingDeviceFromJson(Map<String, dynamic> json) =>
    TrackingDevice(
      id: json['id'] as String?,
      deviceID: json['device_id'] as String,
      time: DateTime.parse(json['time'] as String),
    );

Map<String, dynamic> _$TrackingDeviceToJson(TrackingDevice instance) =>
    <String, dynamic>{
      'id': instance.id,
      'device_id': instance.deviceID,
      'time': instance.time.toIso8601String(),
    };
