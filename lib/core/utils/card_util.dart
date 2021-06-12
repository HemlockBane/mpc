class CardUtil {

  static bool isMasterCard(String? cardPan) {
    if (cardPan == null || cardPan.trim().length < 6) return false;
    return RegExp(r"^5[1-5][0-9]{4}$").hasMatch(cardPan.substring(0, 6));
  }

  static bool isVisaCard(String? cardPan) {
    if (cardPan == null || cardPan.trim().length < 6) return false;
    return RegExp(r"^4[0-9]{5}$").hasMatch(cardPan.substring(0, 6));
  }

  static bool isVerveCard(String? cardPan) {
    if (cardPan == null || cardPan.trim().length < 6) return false;
    final first6 = cardPan.substring(0, 6);
    final digits = int.tryParse(first6);
    if (digits == null) return false;
    return (digits >= 506099 && digits <= 506198) || digits >= 650002 && digits <= 650027;
  }
}
