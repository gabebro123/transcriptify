import 'package:test/test.dart';
import 'package:youtube_transcript_dart/src/transcript_formatters.dart'; // Corrected import path

void main() {
  List<Map<String, dynamic>> transcript = [
    {"text": "Hello, world!", "start": 0.0, "duration": 2.0},
    {"text": "This is a test.", "start": 2.5, "duration": 3.0},
  ];

  test('Pretty Print Formatter', () {
    var formatter = PrettyPrintFormatter();
    String result = formatter.formatTranscript(transcript);
    expect(result, contains("Hello, world!"));
    expect(result, contains("This is a test."));
  });

  test('JSON Formatter', () {
    var formatter = JSONFormatter();
    String result = formatter.formatTranscript(transcript);
    expect(
        result,
        equals('[{"text":"Hello, world!","start":0.0,"duration":2.0},'
            '{"text":"This is a test.","start":2.5,"duration":3.0}]'));
  });

  test('Text Formatter', () {
    var formatter = TextFormatter();
    String result = formatter.formatTranscript(transcript);
    expect(result, equals("Hello, world!\nThis is a test."));
  });

  test('SRT Formatter', () {
    var formatter = SRTFormatter();
    String result = formatter.formatTranscript(transcript);
    expect(result, contains("1\n00:00:00,000 --> 00:00:02,000\nHello, world!"));
    expect(
        result, contains("2\n00:00:02,500 --> 00:00:05,500\nThis is a test."));
  });

  test('WebVTT Formatter', () {
    var formatter = WebVTTFormatter();
    String result = formatter.formatTranscript(transcript);
    expect(result, contains("WEBVTT"));
    expect(result, contains("00:00:00.000 --> 00:00:02.000"));
    expect(result, contains("Hello, world!"));
    expect(result, contains("00:00:02.500 --> 00:00:05.500"));
    expect(result, contains("This is a test."));
  });

  test('Formatter Loader - JSON', () {
    var formatter = FormatterLoader.load("json");
    expect(formatter, isA<JSONFormatter>());
    expect(formatter.formatTranscript(transcript), contains("Hello, world!"));
  });

  test('Formatter Loader - Unknown Type', () {
    expect(() => FormatterLoader.load("unknown"), throwsA(isA<Exception>()));
  });
}
