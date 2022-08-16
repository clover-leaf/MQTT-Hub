// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProject _$UserProjectFromJson(Map<String, dynamic> json) => UserProject(
      id: json['id'] as String?,
      userID: json['user_id'] as String,
      projectID: json['project_id'] as String,
    );

Map<String, dynamic> _$UserProjectToJson(UserProject instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userID,
      'project_id': instance.projectID,
    };
