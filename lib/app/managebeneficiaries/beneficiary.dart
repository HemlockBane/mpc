abstract class Beneficiary {
  String getEntityId();

  String getAccountName();

  String getBeneficiaryDigits();

  String? getBeneficiaryProviderName();

  String? getBeneficiaryProviderCode();

  int? getBeneficiaryColor();

  bool isSelected();

  void setSelected(bool selected);

  int getFrequency() {
    return 0;
  }

  int? getLastUpdated() {
    return DateTime.now().millisecondsSinceEpoch;
  }
}
