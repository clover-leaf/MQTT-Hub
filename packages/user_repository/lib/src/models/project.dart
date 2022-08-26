import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:user_repository/src/models/typedef.dart';
import 'package:uuid/uuid.dart';

part 'generated/project.g.dart';

@immutable
@JsonSerializable()

/// Project model for an API providing to access project
class Project extends Equatable {
  /// {macro Project}
  Project({
    FieldId? id,
    required this.name,
  })  : assert(
          id == null || id.isNotEmpty,
          'id can not be null and should be empty',
        ),
        id = id ?? const Uuid().v4();

  /// The project ID
  final FieldId id;

  /// The name of project
  final String name;

  /// Deserializes the given [JsonMap] into a [Project].
  static Project fromJson(JsonMap json) {
    return _$ProjectFromJson(json);
  }

  /// Converts this [Project] into a [JsonMap].
  JsonMap toJson() => _$ProjectToJson(this);

  /// Returns a copy of [Project] with given parameters
  Project copyWith({
    FieldId? id,
    String? name,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  List<Object?> get props => [id, name];
}
