import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:user_repository/src/models/typedef.dart';
import 'package:uuid/uuid.dart';

part 'group.g.dart';

@immutable
@JsonSerializable()

/// Group model for an API providing to access group
class Group extends Equatable {
  /// {macro Group}
  Group({
    FieldId? id,
    required this.projectID,
    required this.groupID,
    required this.name,
  })  : assert(
          id == null || id.isNotEmpty,
          'id can not be null and should be empty',
        ),
        id = id ?? const Uuid().v4();

  /// The group ID
  final FieldId id;

  @JsonKey(name: 'project_id')

  /// The project ID
  @JsonKey(name: 'project_id')
  final FieldId? projectID;

  /// The parent group ID
  @JsonKey(name: 'group_id')
  final FieldId? groupID;

  /// The name of project
  final String name;

  /// Deserializes the given [JsonMap] into a [Group].
  static Group fromJson(JsonMap json) {
    return _$GroupFromJson(json);
  }

  /// Converts this [Group] into a [JsonMap].
  JsonMap toJson() => _$GroupToJson(this);

  /// Returns a copy of [Group] with given parameters
  Group copyWith({
    FieldId? id,
    FieldId? projectID,
    FieldId? groupID,
    String? name,
  }) {
    return Group(
      id: id ?? this.id,
      projectID: projectID ?? this.projectID,
      groupID: groupID ?? this.groupID,
      name: name ?? this.name,
    );
  }

  @override
  List<Object?> get props => [id, projectID, groupID, name];
}
