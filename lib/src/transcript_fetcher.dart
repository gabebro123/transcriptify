import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:youtube_transcript_dart/src/exceptions.dart';  // ✅ Correct
import 'transcript_list.dart';

class TranscriptFetcher {
  final http.Client _httpClient;

  TranscriptFetcher(this._httpClient);

  Future<TranscriptList> fetch(String videoId) async {
    String html = await _fetchVideoHtml(videoId);
    Map<String, dynamic> captionsJson = _extractCaptionsJson(html, videoId);

    return TranscriptList.build(_httpClient, videoId, captionsJson);
  }

  Map<String, dynamic> _extractCaptionsJson(String html, String videoId) {
    List<String> splitHtml = html.split('"captions":');

    if (splitHtml.length <= 1) {
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
        throw NoTranscriptFound(videoId);
      }

      return jsonData["playerCaptionsTracklistRenderer"];
    } catch (e) {
      throw TranscriptException("Failed to parse captions JSON for video: $videoId. Error: $e");
    }
  }

  Future<String> _fetchVideoHtml(String videoId) async {
    Uri url = Uri.parse("https://www.youtube.com/watch?v=${Uri.encodeFull(videoId)}");
    final response = await _httpClient.get(url, headers: {"Accept-Language": "en-US"});

    if (response.statusCode != 200) {
      throw YouTubeRequestFailed(response.statusCode, videoId);
    }

    return response.body;
  }

  bool _isValidYouTubeId(String videoId) {
    final RegExp idPattern = RegExp(r'^[a-zA-Z0-9_-]{11}$');
    return idPattern.hasMatch(videoId);
  }
}
