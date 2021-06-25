///@author Paul Okeke
class UsernameValidationState {
  final UsernameValidationStatus status;//error, validated, validating
  final String message;

  UsernameValidationState(this.status, this.message);
}

enum UsernameValidationStatus {
  NONE, FAILED, AVAILABLE, ALREADY_TAKEN, VALIDATING
}