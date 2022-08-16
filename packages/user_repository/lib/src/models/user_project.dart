import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:user_repository/src/models/typedef.dart';
import 'package:uuid/uuid.dart';

part 'user_project.g.dart';

@immutable
@JsonSerializable()

/// UserProject model for an API providing to access user-project
class UserProject extends Equatable {
  /// {macro UserProject}
  UserProject({
    FieldId? id,
    required this.userID,
    required this.projectID,
  })  : assert(
          id == null || id.isNotEmpty,
          'id can not be null and should be empty',
        ),
        id = id ?? const Uuid().v4();

  /// The user-project ID
  final FieldId id;

  /// The ID of user
  @JsonKey(name: 'user_id')
  final FieldId userID;

  /// The ID of project
  @JsonKey(name: 'project_id')
  final FieldId projectID;

  /// Deserializes the given [JsonMap] into a [UserProject].
  static UserProject fromJson(JsonMap json) {
    return _$UserProjectFromJson(json);
  }

  /// Converts this [UserProject] into a [JsonMap].
  JsonMap toJson() => _$UserProjectToJson(this);

  /// Returns a copy of [UserProject] with given parameters
  UserProject copyWith({
    FieldId? id,
    FieldId? userID,
    FieldId? projectID,
  }) {
    return UserProject(
      id: id ?? this.id,
      userID: userID ?? this.userID,
      projectID: projectID ?? this.projectID,
    );
  }

  @override
  List<Object?> get props => [id, userID, projectID];
}
