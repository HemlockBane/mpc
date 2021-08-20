import 'package:moniepoint_flutter/app/managebeneficiaries/beneficiary.dart';
import 'package:moniepoint_flutter/app/managebeneficiaries/transfer/model/data/transfer_beneficiary.dart';

class CandidateBankUtil {
  static const int BANK_CODE_LENGTH = 6;
  static const int SERIAL_NUMBER_LENGTH = 9;
  static const int ACCOUNT_NUMBER_LENGTH = 10;
  static const String BANK_CODE_INVALID_MESSAGE = "Bank code should only contain digits and should be %s digits";
  static const String ACCOUNT_NUMBER_INVALID_MESSAGE = "Account number should only contain digits and should be %s digits";
  static const String SERIAL_NUMBER_INVALID_MESSAGE = "Serial number should be %s digits";
  static const int CHECK_DIGIT_INDEX = 9;

  static final List<int> serialCoefficients = List.of([3, 7, 3, 3, 7, 3, 3, 7, 3]);

  static final List<int> bankCodeCoefficients = List.of([3, 7, 3, 3, 7, 3]);

  static List<String> getMatchingBanks(Set<String> bankCodes, String accountNumber) {
    if (!_isAccountNumberValid(accountNumber)) {
      throw new FormatException("$ACCOUNT_NUMBER_INVALID_MESSAGE, $ACCOUNT_NUMBER_LENGTH");
    }

    List<String> matches = [];

    String serialNumber = accountNumber.substring(0, SERIAL_NUMBER_LENGTH);
    int checkDigit = _charToInt(accountNumber[CHECK_DIGIT_INDEX]);
    int serialAggregate = _getSerialNumberAggregate(serialNumber);

    for (String bankCode in bankCodes) {
      int totalAggregate = _getBankCodeAggregate(bankCode) + serialAggregate;
      int modulus = _getModulus(totalAggregate);
      int calculatedCheckDigit = _getCheckDigit(modulus);

      if (_isBankCodeMatch(checkDigit, calculatedCheckDigit)) {
        matches.add(bankCode);
      }
    }

    return matches;
  }

  static int _getBankCodeAggregate(String bankCode) {
    if (!_isBankCodeValid(bankCode)) {
      throw new FormatException("$BANK_CODE_INVALID_MESSAGE, $BANK_CODE_LENGTH");
    }

    int sum = 0;
    for (int i = 0; i < BANK_CODE_LENGTH; i++) {
      sum += bankCodeCoefficients[i] * _charToInt(bankCode[i]);
    }

    return sum;
  }

  static int _getSerialNumberAggregate(String serialNumber) {
    if (!_isSerialNumberValid(serialNumber)) {
      throw new FormatException(SERIAL_NUMBER_INVALID_MESSAGE, SERIAL_NUMBER_LENGTH);
    }

    int sum = 0;
    for (int i = 0; i < SERIAL_NUMBER_LENGTH; i++) {
      sum += serialCoefficients[i] * _charToInt(serialNumber[i]);
    }

    return sum;
  }

  static int _getModulus(int aggregatedSum) {
    return aggregatedSum % 10;
  }

  static int _getCheckDigit(int modulus) {
    return modulus == 0 ? 0 : 10 - modulus;
  }

  static bool _isBankCodeMatch(int actualCheckDigit, int calculatedCheckDigit) {
    return actualCheckDigit == calculatedCheckDigit;
  }

  static bool _isBankCodeValid(String bankCode) {
    return bankCode.length == BANK_CODE_LENGTH && RegExp(r'[0-9]+').hasMatch(bankCode);
  }

  static bool _isAccountNumberValid(String accountNumber) {
    return accountNumber.length == ACCOUNT_NUMBER_LENGTH && RegExp(r'[0-9]+').hasMatch(accountNumber);
  }

  static bool _isSerialNumberValid(String serialNumber) {
    return serialNumber.length == SERIAL_NUMBER_LENGTH && RegExp(r'[0-9]+').hasMatch(serialNumber);
  }

  static int _charToInt(String c) {
    return int.parse(c);//Integer.parseInt(Character.toString(c));
  }

  static bool isIntra(String beneficiaryProviderCode) {
    return beneficiaryProviderCode == "950515";
  }
}
