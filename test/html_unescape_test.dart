import 'package:test/test.dart';
import 'package:youtube_transcript_dart/src/html_unescape.dart';

void main() {
  test('Unescape HTML entities', () {
    expect(HtmlUnescape.unescape("&lt;Hello&gt; &amp; Welcome!"), "<Hello> & Welcome!");
  });

  test('Handle text without HTML entities', () {
    expect(HtmlUnescape.unescape("Just normal text"), "Just normal text");
  });
}
