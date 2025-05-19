class StringsHelper {
  static String capitalize(String s) {
    if (s.isEmpty) return s;
    return s
        .toLowerCase()
        .split(" ")
        .map((word) =>
            word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : "")
        .join(" ");
  }

  static String sanitizeInput(String input) {
    if (input.isEmpty) return input;

    return input
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#39;')
        .replaceAll('/', '&#x2F;')
        .replaceAll('`', '&#96;');
  }

  static String truncateText(String text, int length) {
    if (text.length > length) {
      return '${text.substring(0, length)}...';
    }
    return text;
  }
}
