import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:user_repository/src/models/typedef.dart';
import 'package:uuid/uuid.dart';

part 'generated/alert.g.dart';

@immutable
@JsonSerializable()

/// Alert model for an API providing to access alert
class Alert extends Equatable {
  /// {macro Alert}
  Alert({
    FieldId? id,
    required this.deviceID,
    required this.name,
  })  : assert(
          id == null || id.isNotEmpty,
          'id can not be null and should be empty',
        ),
        id = id ?? const Uuid().v4();

  /// The ID
  final FieldId id;

  /// The project ID
  @JsonKey(name: 'device_id')
  final FieldId deviceID;

  /// The name of alert
  final String name;

  /// Deserializes the given [JsonMap] into a [Alert].
  static Alert fromJson(JsonMap json) {
    return _$AlertFromJson(json);
  }

  /// Converts this [Alert] into a [JsonMap].
  JsonMap toJson() => _$AlertToJson(this);

  /// Returns a copy of [Alert] with given parameters
  Alert copyWith({
    FieldId? id,
    FieldId? deviceID,
    String? name,
  }) {
    return Alert(
      id: id ?? this.id,
      deviceID: deviceID ?? this.deviceID,
      name: name ?? this.name,
    );
  }

  @override
  List<Object?> get props => [id, deviceID, name];
}
