import 'package:test/test.dart';
import '../lib/src/html_unescape.dart';  // ✅ Correct

void main() {
  test('Unescape HTML entities', () {
    expect(HtmlUnescape.unescape("&lt;Hello&gt; &amp; Welcome!"), "<Hello> & Welcome!");
  });

  test('Handle text without HTML entities', () {
    expect(HtmlUnescape.unescape("Just normal text"), "Just normal text");
  });
}
