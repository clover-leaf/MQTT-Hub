import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:user_repository/src/models/typedef.dart';
import 'package:uuid/uuid.dart';

part 'generated/dashboard.g.dart';

@immutable
@JsonSerializable()

/// Dashboard model for an API providing to access dashboard
class Dashboard extends Equatable {
  /// {macro Dashboard}
  Dashboard({
    FieldId? id,
    required this.projectID,
    required this.name,
  })  : assert(
          id == null || id.isNotEmpty,
          'id can not be null and should be empty',
        ),
        id = id ?? const Uuid().v4();

  /// The ID
  final FieldId id;

  /// The device ID
  @JsonKey(name: 'project_id')
  final FieldId projectID;

  /// The name of dashboard
  final String name;

  /// Deserializes the given [JsonMap] into a [Dashboard].
  static Dashboard fromJson(JsonMap json) {
    return _$DashboardFromJson(json);
  }

  /// Converts this [Dashboard] into a [JsonMap].
  JsonMap toJson() => _$DashboardToJson(this);

  /// Returns a copy of [Dashboard] with given parameters
  Dashboard copyWith({
    FieldId? id,
    FieldId? projectID,
    String? name,
  }) {
    return Dashboard(
      id: id ?? this.id,
      projectID: projectID ?? this.projectID,
      name: name ?? this.name,
    );
  }

  @override
  List<Object?> get props => [id, projectID, name];
}
