/// A utility class for filtering ASCII characters from a string.
/// It provides a method to return a new string containing only the ASCII
/// characters from the input string.
class AsciiOnly {
  /// Returns a new string containing only the ASCII characters from the input [String].
  static String filter(String input) {
    final buffer = StringBuffer();

    for (int i = 0; i < input.length; i++) {
      final char = input[i];

      if (char.codeUnitAt(0) < 128) {
        buffer.write(char);
      }
    }

    return buffer.toString();
  }
}
