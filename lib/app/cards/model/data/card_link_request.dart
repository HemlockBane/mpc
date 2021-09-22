import 'dart:io';

class CardLinkRequest {
  final File firstCapture;
  final File motionCapture;
  final String customerId;
  final String customerAccountId;
  final String? otpValidationKey;
  int? cardId;
  String? customerCode;
  String? cardSerial;
  String? cvv;
  String? newPin;

  CardLinkRequest(
      {required this.firstCapture,
      required this.motionCapture,
      required this.customerId,
      required this.customerAccountId,
      this.customerCode,
      this.otpValidationKey,
      this.cardId,
      this.cardSerial,
      this.cvv,
      this.newPin});
}
