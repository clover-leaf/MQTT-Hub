// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../tracking_attribute.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrackingAttribute _$TrackingAttributeFromJson(Map<String, dynamic> json) =>
    TrackingAttribute(
      id: json['id'] as String?,
      trackingDeviceID: json['tracking_device_id'] as String,
      attributeID: json['attribute_id'] as String,
      value: json['value'] as String,
    );

Map<String, dynamic> _$TrackingAttributeToJson(TrackingAttribute instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tracking_device_id': instance.trackingDeviceID,
      'attribute_id': instance.attributeID,
      'value': instance.value,
    };
