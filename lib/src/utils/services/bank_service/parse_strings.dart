class Parser {
  static String link = r'href="([^"]+)"';
  static String paRes = r'<input[^>]*name="PaRes"[^>]*value="([^"]+)"[^>]*>';

  static String attempt = r'Attempt (\d+) of \d+';
  static String attemptWrong = r'Wrong password typed attempt \d+ of \d+';

  static String threeDSecurePhoneTipBegin = 'One-time password will be sent to number ';
  static String threeDSecurePhoneTipEnd = '</span>';

  static String operationCancelledMessage = 'Operation cancelled';

  static String merchant = r'Merchant<\/td>\s+<td class="middleColumn">:<\/td>\s+<td class="valueColumn">(.+)<\/td>';
  static String date = r'Date<\/td>\s+<td class="middleColumn">:<\/td>\s+<td class="valueColumn">(.+)<\/td>';
  static String amount =
      r'Amount<\/td>\s+<td class="middleColumn">:<\/td>\s+<td class="valueColumn"><span class="amountOutput">(.+)<\/span>';
  static String cardNumber =
      r'Card number<\/td>\s+<td class="middleColumn">:<\/td>\s+<td class="valueColumn">(.+)<\/td>';

  static String extractLinkFromHtmlString(String htmlString) {
    final RegExp hrefRegex = RegExp(link);
    final match = hrefRegex.firstMatch(htmlString);
    return match?.group(1) ?? '';
  }

  static String extractPhoneNumber(String htmlString) {
    int startIndex = htmlString.indexOf(threeDSecurePhoneTipBegin);
    if (startIndex == -1) return '';

    startIndex += threeDSecurePhoneTipBegin.length;

    final endIndex = htmlString.indexOf(threeDSecurePhoneTipEnd, startIndex);

    if (endIndex == -1) return '';

    return htmlString.substring(startIndex, endIndex);
  }

  // static String extractMerchant(String htmlString) {
  // final RegExp regex = RegExp(merchant);
  // final match = regex.firstMatch(htmlString);
  // return match?.group(1) ?? '';
  // }

  static String extractAmount(String htmlString) {
    final RegExp regex = RegExp(amount);
    final match = regex.firstMatch(htmlString);
    return match?.group(1) ?? '';
  }

  static String extractDate(String htmlString) {
    final RegExp regex = RegExp(date);
    final match = regex.firstMatch(htmlString);
    return match?.group(1) ?? '';
  }

  static String extractCardNumber(String htmlString) {
    final RegExp regex = RegExp(cardNumber);
    final match = regex.firstMatch(htmlString);
    return match?.group(1) ?? '';
  }

  static String extractAttempt(String htmlString) {
    RegExp regex = RegExp(attempt, multiLine: true);
    RegExpMatch? match = regex.firstMatch(htmlString);
    return match?.group(0) ?? '';
  }

  static String extractWrongAttempt(String htmlString) {
    final regex = RegExp(attemptWrong);
    final match = regex.firstMatch(htmlString);
    return match?.group(0) ?? '';
  }

  static String extractPaRes(String htmlString) {
    RegExp regex = RegExp(paRes);
    Match? match = regex.firstMatch(htmlString);
    return match?.group(1)! ?? '';
  }

  static bool isOperationCancelled(String htmlString) {
    RegExp regex = RegExp(operationCancelledMessage);
    return regex.hasMatch(htmlString);
  }
}
