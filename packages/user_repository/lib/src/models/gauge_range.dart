import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:user_repository/src/models/typedef.dart';

part 'generated/gauge_range.g.dart';

@immutable
@JsonSerializable()

///
class GaugeRange extends Equatable {
  /// {macro GaugeRange}
  const GaugeRange({
    required this.color,
    this.min,
    this.max,
  });

  ///
  final String? min;

  ///
  final String? max;

  ///
  final String color;

  /// Deserializes the given [JsonMap] into a [GaugeRange].
  static GaugeRange fromJson(JsonMap json) {
    return _$GaugeRangeFromJson(json);
  }

  /// Converts this [GaugeRange] into a [JsonMap].
  JsonMap toJson() => _$GaugeRangeToJson(this);

  /// Returns a copy of [GaugeRange] with given parameters
  GaugeRange copyWith({
    String? min,
    String? max,
    String? color,
  }) {
    return GaugeRange(
      min: min ?? this.min,
      max: max ?? this.max,
      color: color ?? this.color,
    );
  }

  @override
  List<Object?> get props => [min, max, color];
}
