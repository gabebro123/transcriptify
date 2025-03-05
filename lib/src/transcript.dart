import 'package:http/http.dart' as http;
import 'package:youtube_transcript_dart/src/exceptions.dart';  // ✅ Correct
import 'transcript_parser.dart';

class Transcript {
  final http.Client _httpClient;
  final String videoId;
  final String url;
  final String name;
  final String languageCode;
  final bool isGenerated;
  final List<Map<String, String>> translationLanguages;

  Transcript(
    this._httpClient,
    this.videoId,
    this.url,
    this.name,
    this.languageCode,
    this.isGenerated,
    this.translationLanguages,
  );

  /// Fetches and parses the transcript
  Future<List<Map<String, dynamic>>> fetch() async {
    final response = await _httpClient.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw YouTubeRequestFailed(response.statusCode, videoId);
    }

    return TranscriptParser.parseTranscript(response.body);
  }
}
