class NumbersHelper {
  static String formatDouble(double value) {
    List<String> parts = value.toStringAsFixed(2).split('.');
    String integerPart = parts[0];
    String decimalPart = parts[1];

    String formattedInt = '';
    for (int i = 0; i < integerPart.length; i++) {
      int reversedIndex = integerPart.length - 1 - i;
      formattedInt = integerPart[reversedIndex] + formattedInt;
      if ((i + 1) % 3 == 0 && reversedIndex != 0) {
        formattedInt = '.$formattedInt';
      }
    }

    return '$formattedInt,$decimalPart';
  }
}
