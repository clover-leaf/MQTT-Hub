import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:user_repository/src/models/typedef.dart';

part 'generated/toggle_config.g.dart';

@immutable
@JsonSerializable()

///
class ToggleConfig extends Equatable {
  /// {macro ToggleConfig}
  const ToggleConfig({
    required this.value,
    required this.color,
    this.label,
  });

  ///
  factory ToggleConfig.placeholder() =>
      const ToggleConfig(value: '', color: '');

  ///
  final String value;

  ///
  final String? label;

  ///
  final String color;

  /// Deserializes the given [JsonMap] into a [ToggleConfig].
  static ToggleConfig fromJson(JsonMap json) {
    return _$ToggleConfigFromJson(json);
  }

  /// Converts this [ToggleConfig] into a [JsonMap].
  JsonMap toJson() => _$ToggleConfigToJson(this);

  /// Returns a copy of [ToggleConfig] with given parameters
  ToggleConfig copyWith({
    String? value,
    String? label,
    String? color,
  }) {
    return ToggleConfig(
      value: value ?? this.value,
      label: label ?? this.label,
      color: color ?? this.color,
    );
  }

  @override
  List<Object?> get props => [value, label, color];
}
