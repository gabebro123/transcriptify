import 'package:youtube_transcript_dart/src/exceptions.dart'; // Corrected import path
import 'package:youtube_transcript_dart/src/transcript_fetcher.dart'; // Corrected import path
import 'package:http/http.dart' as http_client;

class YouTubeTranscriptApi {
  static final http_client.Client _httpClient = http_client.Client();

  /// Fetches the transcript for a given YouTube video ID.
  static Future<List<Map<String, dynamic>>> getTranscript(String videoId,
      {List<String> languages = const ["en"]}) async {
    try {
      final fetcher = TranscriptFetcher(_httpClient);
      final transcriptList = await fetcher.fetch(videoId);

      for (String lang in languages) {
        if (transcriptList.manuallyCreatedTranscripts.containsKey(lang)) {
          return await transcriptList.manuallyCreatedTranscripts[lang]!.fetch();
        }
        if (transcriptList.generatedTranscripts.containsKey(lang)) {
          return await transcriptList.generatedTranscripts[lang]!.fetch();
        }
      }

      throw NoTranscriptFound(videoId); // Correct exception now thrown
    } catch (e) {
      if (e is NoTranscriptFound) {
        rethrow; // Preserve NoTranscriptFound exception
      }
      if (e is InvalidVideoId) {
        throw NoTranscriptFound(
            videoId); // Handle specific case for no captions
      }
      throw TranscriptException("Error fetching transcript: $e");
    }
  }

  /// Fetches transcripts for multiple YouTube videos.
  static Future<Map<String, List<Map<String, dynamic>>>> getTranscripts(
      List<String> videoIds,
      {List<String> languages = const ["en"],
      bool continueAfterError = false}) async {
    Map<String, List<Map<String, dynamic>>> data = {};
    List<String> failedVideos = [];

    for (String videoId in videoIds) {
      try {
        data[videoId] = await getTranscript(videoId, languages: languages);
      } catch (e) {
        if (!continueAfterError) {
          throw e;
        }
        failedVideos.add(videoId);
      }
    }

    return data;
  }
}
