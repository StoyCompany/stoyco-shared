import 'package:equatable/equatable.dart';

/// Data transfer object for nickname validation.
class NickNameValidationDTO extends Equatable {
  /// Constructs a [NickNameValidationDTO] with the given parameters.
  const NickNameValidationDTO({
    required this.validateMessage,
    required this.isValid,
  });

  /// The validation message for the nickname.
  final String? validateMessage;

  /// Indicates whether the nickname is valid or not.
  final bool? isValid;

  @override
  List<Object?> get props => [validateMessage, isValid];

  /// Creates a copy of this [NickNameValidationDTO] with the given parameters.
  NickNameValidationDTO copyWith({String? validateMessage, bool? isValid}) =>
      NickNameValidationDTO(
        validateMessage: validateMessage ?? this.validateMessage,
        isValid: isValid ?? this.isValid,
      );
}
