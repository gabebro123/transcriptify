import 'package:html/parser.dart';

class HtmlUnescape {
  /// Unescapes HTML entities in a given string.
  static String unescape(String text) {
    return parse(text).body?.text ?? text;
  }
}
