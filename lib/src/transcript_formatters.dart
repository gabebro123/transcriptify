import 'dart:convert';

/// Abstract base class for transcript formatters.
abstract class TranscriptFormatter {
  /// Formats a single transcript.
  String formatTranscript(List<Map<String, dynamic>> transcript);

  /// Formats multiple transcripts.
  String formatTranscripts(List<List<Map<String, dynamic>>> transcripts);
}

/// Pretty print formatter
class PrettyPrintFormatter extends TranscriptFormatter {
  @override
  String formatTranscript(List<Map<String, dynamic>> transcript) {
    return const JsonEncoder.withIndent("  ").convert(transcript);
  }

  @override
  String formatTranscripts(List<List<Map<String, dynamic>>> transcripts) {
    return transcripts.map((t) => formatTranscript(t)).join("\n\n\n");
  }
}

/// JSON formatter
class JSONFormatter extends TranscriptFormatter {
  @override
  String formatTranscript(List<Map<String, dynamic>> transcript) {
    return jsonEncode(transcript);
  }

  @override
  String formatTranscripts(List<List<Map<String, dynamic>>> transcripts) {
    return transcripts.map((t) => formatTranscript(t)).join("\n\n\n");
  }
}

/// Plain text formatter
class TextFormatter extends TranscriptFormatter {
  @override
  String formatTranscript(List<Map<String, dynamic>> transcript) {
    return transcript.map((line) => line["text"]).join("\n");
  }

  @override
  String formatTranscripts(List<List<Map<String, dynamic>>> transcripts) {
    return transcripts.map((t) => formatTranscript(t)).join("\n\n\n");
  }
}

/// Abstract class for text-based formats like SRT and WebVTT
abstract class _TextBasedFormatter extends TextFormatter {
  String _formatTimestamp(int hours, int mins, int secs, int ms);

  String _formatTranscriptHeader(List<String> lines);

  String _formatTranscriptHelper(int index, String timeText, Map<String, dynamic> line);

  String _secondsToTimestamp(double time) {
    int hours = (time ~/ 3600);
    int mins = ((time % 3600) ~/ 60);
    int secs = (time % 60).toInt();
    int ms = ((time - time.toInt()) * 1000).toInt();
    return _formatTimestamp(hours, mins, secs, ms);
  }

  @override
  String formatTranscript(List<Map<String, dynamic>> transcript) {
    List<String> lines = [];
    for (int i = 0; i < transcript.length; i++) {
      double start = transcript[i]["start"];
      double end = start + (transcript[i]["duration"] ?? 0);
      String timeText = "${_secondsToTimestamp(start)} --> ${_secondsToTimestamp(end)}";
      lines.add(_formatTranscriptHelper(i, timeText, transcript[i]));
    }
    return _formatTranscriptHeader(lines);
  }
}

/// SRT Formatter
class SRTFormatter extends _TextBasedFormatter {
  @override
  String _formatTimestamp(int hours, int mins, int secs, int ms) {
    return "${hours.toString().padLeft(2, '0')}:${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')},${ms.toString().padLeft(3, '0')}";
  }

  @override
  String _formatTranscriptHeader(List<String> lines) {
    return lines.join("\n\n") + "\n";
  }

  @override
  String _formatTranscriptHelper(int index, String timeText, Map<String, dynamic> line) {
    return "${index + 1}\n$timeText\n${line["text"]}";
  }
}

/// WebVTT Formatter
class WebVTTFormatter extends _TextBasedFormatter {
  @override
  String _formatTimestamp(int hours, int mins, int secs, int ms) {
    return "${hours.toString().padLeft(2, '0')}:${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}.${ms.toString().padLeft(3, '0')}";
  }

  @override
  String _formatTranscriptHeader(List<String> lines) {
    return "WEBVTT\n\n" + lines.join("\n\n") + "\n";
  }

  @override
  String _formatTranscriptHelper(int index, String timeText, Map<String, dynamic> line) {
    return "$timeText\n${line["text"]}";
  }
}

/// Loads formatters based on type
class FormatterLoader {
  static final Map<String, TranscriptFormatter> _formatterTypes = {
    "json": JSONFormatter(),
    "pretty": PrettyPrintFormatter(),
    "text": TextFormatter(),
    "webvtt": WebVTTFormatter(),
    "srt": SRTFormatter(),
  };

  static TranscriptFormatter load(String formatterType) {
    if (!_formatterTypes.containsKey(formatterType)) {
      throw Exception("Unknown formatter type: $formatterType");
    }
    return _formatterTypes[formatterType]!;
  }
}
