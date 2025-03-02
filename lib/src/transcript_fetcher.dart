import 'dart:convert';
import 'package:http/http.dart' as http;
import '../exceptions.dart';  // ✅ Correct
import 'transcript_list.dart';  // ✅ Ensure this exists and defines `TranscriptList`

class TranscriptFetcher {
  final http.Client _httpClient;

  TranscriptFetcher(this._httpClient);

  /// Fetches the list of available transcripts for a given YouTube video.
  Future<TranscriptList> fetch(String videoId) async {
    String html = await _fetchVideoHtml(videoId);
    Map<String, dynamic> captionsJson = _extractCaptionsJson(html, videoId);

    return TranscriptList.build(_httpClient, videoId, captionsJson);
  }

  /// Extracts the captions JSON from YouTube's HTML response.
  Map<String, dynamic> _extractCaptionsJson(String html, String videoId) {
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
        throw NoTranscriptFound(videoId);  // ✅ Throw NoTranscriptFound if no captions are available
      }

      return jsonData["playerCaptionsTracklistRenderer"];
    } catch (e) {
      throw TranscriptException("Failed to parse captions JSON for video: $videoId. Error: $e");
    }
  }

  /// Fetches the HTML source of a YouTube video page.
  Future<String> _fetchVideoHtml(String videoId) async {
    Uri url = Uri.parse("https://www.youtube.com/watch?v=${Uri.encodeFull(videoId)}");
    final response = await _httpClient.get(url, headers: {"Accept-Language": "en-US"});

    if (response.statusCode != 200) {
        throw YouTubeRequestFailed(response.statusCode, videoId);
    }

    return response.body;
  }

  /// Validates YouTube video ID format.
  bool _isValidYouTubeId(String videoId) {
    final RegExp idPattern = RegExp(r'^[a-zA-Z0-9_-]{11}$');
    return idPattern.hasMatch(videoId);
  }
}