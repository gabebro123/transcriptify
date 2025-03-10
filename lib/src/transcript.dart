import 'package:http/http.dart' as http;
import 'package:youtube_transcript_dart/src/exceptions.dart'; // ✅ Correct
import 'transcript_parser.dart';

/// Represents a YouTube video transcript.
class Transcript {
  /// The HTTP client used to fetch the transcript.
  final http.Client _httpClient;

  /// The ID of the YouTube video.
  final String videoId;

  /// The URL of the transcript.
  final String url;

  /// The name of the transcript.
  final String name;

  /// The language code of the transcript.
  final String languageCode;

  /// Indicates whether the transcript is generated or manually created.
  final bool isGenerated;

  /// The list of translation languages available for the transcript.
  final List<Map<String, String>> translationLanguages;

  /// Creates a new [Transcript] instance.
  Transcript(
    this._httpClient,
    this.videoId,
    this.url,
    this.name,
    this.languageCode,
    this.isGenerated,
    this.translationLanguages,
  );

  /// Fetches and parses the transcript.
  ///
  /// Throws a [YouTubeRequestFailed] exception if the request fails.
  Future<List<Map<String, dynamic>>> fetch() async {
    final response = await _httpClient.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw YouTubeRequestFailed(response.statusCode, videoId);
    }

    return TranscriptParser.parseTranscript(response.body);
  }
}
