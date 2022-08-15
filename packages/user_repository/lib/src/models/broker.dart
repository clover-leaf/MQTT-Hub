import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:user_repository/src/models/typedef.dart';
import 'package:uuid/uuid.dart';

part 'broker.g.dart';

@immutable
@JsonSerializable()

/// Broker model for an API providing to access broker
class Broker extends Equatable {
  /// {macro Broker}
  Broker({
    FieldId? id,
    required this.projectID,
    required this.name,
    required this.url,
    required this.account,
    required this.password,
  })  : assert(
          id == null || id.isNotEmpty,
          'id can not be null and should be empty',
        ),
        id = id ?? const Uuid().v4();

  /// The ID
  final FieldId id;

  /// The project ID
  @JsonKey(name: 'project_id')
  final FieldId projectID;

  /// The name of broker
  final String name;

  /// The url of broker
  final String url;

  /// The account of broker
  final String? account;

  /// The password of broker
  final String? password;

  /// Deserializes the given [JsonMap] into a [Broker].
  static Broker fromJson(JsonMap json) {
    return _$BrokerFromJson(json);
  }

  /// Converts this [Broker] into a [JsonMap].
  JsonMap toJson() => _$BrokerToJson(this);

  /// Returns a copy of [Broker] with given parameters
  Broker copyWith({
    FieldId? id,
    FieldId? projectID,
    String? name,
    String? url,
    String? account,
    String? password,
  }) {
    return Broker(
      id: id ?? this.id,
      projectID: projectID ?? this.projectID,
      name: name ?? this.name,
      url: url ?? this.url,
      account: account ?? this.account,
      password: password ?? this.password,
    );
  }

  @override
  List<Object?> get props => [id, projectID, name, url, account, password];
}
