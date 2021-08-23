import 'package:moniepoint_flutter/core/utils/candidate_bank_util.dart';

abstract class Beneficiary {

  int getRecordId();

  String getEntityId();

  String getAccountName();

  String getBeneficiaryDigits();

  String? getBeneficiaryProviderName();

  String? getBeneficiaryProviderCode();

  int? getBeneficiaryColor();

  bool isIntraBank() {
    return CandidateBankUtil.isIntra(getBeneficiaryProviderCode() ?? "");
  }

  bool isSelected();

  void setSelected(bool selected);

  int getFrequency() {
    return 0;
  }

  int? getLastUpdated() {
    return DateTime.now().millisecondsSinceEpoch;
  }
}
