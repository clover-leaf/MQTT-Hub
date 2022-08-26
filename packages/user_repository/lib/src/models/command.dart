import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:user_repository/src/models/typedef.dart';

part 'generated/command.g.dart';

@immutable
@JsonSerializable()

///
class Command extends Equatable {
  /// {macro Command}
  const Command({
    required this.icon,
    required this.label,
    required this.value,
  });

  ///
  final String label;

  ///
  final String value;

  ///
  final String icon;

  /// Deserializes the given [JsonMap] into a [Command].
  static Command fromJson(JsonMap json) {
    return _$CommandFromJson(json);
  }

  /// Converts this [Command] into a [JsonMap].
  JsonMap toJson() => _$CommandToJson(this);

  /// Returns a copy of [Command] with given parameters
  Command copyWith({
    String? label,
    String? value,
    String? icon,
  }) {
    return Command(
      label: label ?? this.label,
      value: value ?? this.value,
      icon: icon ?? this.icon,
    );
  }

  @override
  List<Object?> get props => [label, value, icon];
}
