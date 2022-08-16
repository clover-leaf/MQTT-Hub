import 'package:formz/formz.dart';

/// TopicName Form Input Validation Error.
enum TopicNameValidationError {
  /// TopicName is invalid (generic validation error).
  invalid
}

/// {@template TopicName}
/// Reusable TopicName form input.
/// {@endtemplate}
class TopicName extends FormzInput<String, TopicNameValidationError> {
  /// {@macro TopicName}
  const TopicName.pure() : super.pure('');

  /// {@macro TopicName}
  const TopicName.dirty([super.value = '']) : super.dirty();

  @override
  TopicNameValidationError? validator(String value) {
    return value.isNotEmpty ? null : TopicNameValidationError.invalid;
  }
}
