import 'package:html/parser.dart';
import 'package:html/dom.dart';

class TranscriptParser {
  /// Parses a YouTube transcript XML response into a list of transcript entries.
  static List<Map<String, dynamic>> parseTranscript(String xmlString) {
    try {
      final Document document = parse(xmlString);  // Ensure it's a valid Document
      final Element? rootElement = document.documentElement;

      if (rootElement == null) {
        throw Exception("Invalid transcript XML structure: No root element found.");
      }

      final List<Element> transcriptElements = rootElement.getElementsByTagName("text");

      return transcriptElements.map((element) {
        return {
          "text": element.text.trim(), // Trim to remove unnecessary spaces
          "start": _parseDouble(element.attributes["start"]), // Convert safely
          "duration": _parseDouble(element.attributes["dur"]), // Convert safely
        };
      }).toList();
    } catch (e) {
      throw Exception("Error parsing transcript XML: $e");
    }
  }

  /// Safely parses a string into a double, returning 0.0 if parsing fails.
  static double _parseDouble(String? value) {
    if (value == null || value.isEmpty) return 0.0;
    return double.tryParse(value) ?? 0.0;
  }
}