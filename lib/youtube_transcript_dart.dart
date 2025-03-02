import '../src/exceptions.dart';  // ✅ Relative path
import 'package:http/http.dart' as http; // Import the http package
import 'dart:convert'; // Import the dart:convert package for JSON decoding

class YouTubeTranscript {
  static Future<List<Map<String, dynamic>>> getTranscript(
      String videoId,
      {List<String> languages = const ["en"],
      Map<String, String>? proxies}) async {

    List<Map<String, dynamic>> transcriptList =
        await listTranscripts(videoId, proxies: proxies);

    // Find the best match for the requested language
    for (String lang in languages) {
      for (var transcript in transcriptList) {
        if (transcript["languageCode"] == lang) {
          return await _fetchTranscript(transcript["baseUrl"]);
        }
      }
    }

    throw NoTranscriptFound(videoId);  // ✅ Changed from `TranscriptException`
  }

  static Future<List<Map<String, dynamic>>> listTranscripts(
      String videoId, {Map<String, String>? proxies}) async {
    try {
      final url = Uri.parse("https://www.youtube.com/watch?v=$videoId");
      final response = await http.get(url, headers: proxies ?? {});

      if (response.statusCode != 200) {
        throw TranscriptException("Failed to fetch transcript list for $videoId");
      }

      final captionsJson = _extractCaptionsJson(response.body, videoId);

      if (captionsJson.isEmpty) {
        throw NoTranscriptFound(videoId);  // ✅ Ensure correct exception is thrown
      }

      return [captionsJson];
    } catch (e) {
      if (e is NoTranscriptFound) {
        rethrow;  // ✅ Preserve NoTranscriptFound
      }
      throw TranscriptException("Error fetching transcript list: $e");
    }
  }

  static Future<List<Map<String, dynamic>>> _fetchTranscript(String baseUrl) async {
    // Implement the method to fetch transcript
    // This is a placeholder implementation
    return [];
  }

  static Map<String, dynamic> _extractCaptionsJson(String html, String videoId) {
    List<String> splitHtml = html.split('"captions":');

    if (splitHtml.length <= 1) {
      // Validate video ID format
      if (!_isValidYouTubeId(videoId)) {
        throw InvalidVideoId(videoId);
      }
      if (html.contains('class="g-recaptcha"')) {
        throw TooManyRequests(videoId);
      }
      if (!html.contains('"playabilityStatus":')) {
        throw VideoUnavailable(videoId);
      }

      throw TranscriptsDisabled(videoId);
    }

    try {
      String jsonString = splitHtml[1].split(',"videoDetails')[0].replaceAll("\n", "");
      Map<String, dynamic> jsonData = jsonDecode(jsonString);

      if (jsonData["playerCaptionsTracklistRenderer"] == null) {
        throw TranscriptsDisabled(videoId);
      }

      return jsonData["playerCaptionsTracklistRenderer"];
    } catch (e) {
      throw TranscriptException("Failed to parse captions JSON for video: $videoId. Error: $e");
    }
  }

  static bool _isValidYouTubeId(String videoId) {
    final RegExp idPattern = RegExp(r'^[a-zA-Z0-9_-]{11}$');
    return idPattern.hasMatch(videoId);
  }
}
