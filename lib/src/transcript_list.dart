import 'package:http/http.dart' as http;
import 'package:youtube_transcript_dart/src/transcript.dart'; // ✅ Correct

class TranscriptList {
  final Map<String, Transcript> manuallyCreatedTranscripts;
  final Map<String, Transcript> generatedTranscripts;

  TranscriptList({
    required this.manuallyCreatedTranscripts,
    required this.generatedTranscripts,
  });

  static Future<TranscriptList> build(http.Client httpClient, String videoId,
      Map<String, dynamic> captionsJson) async {
    final manuallyCreatedTranscripts = <String, Transcript>{};
    final generatedTranscripts = <String, Transcript>{};

    for (var track in captionsJson['captionTracks'] ?? []) {
      final transcript = Transcript(
        httpClient,
        videoId,
        track['baseUrl'],
        track['name']['simpleText'],
        track['languageCode'],
        track['kind'] == 'asr',
        (track['translationLanguages'] as List<dynamic>? ?? []).map((lang) {
          return {
            'languageCode': lang['languageCode'] as String,
            'languageName': lang['languageName'] as String,
          };
        }).toList(),
      );

      if (transcript.isGenerated) {
        generatedTranscripts[transcript.languageCode] = transcript;
      } else {
        manuallyCreatedTranscripts[transcript.languageCode] = transcript;
      }
    }

    return TranscriptList(
      manuallyCreatedTranscripts: manuallyCreatedTranscripts,
      generatedTranscripts: generatedTranscripts,
    );
  }
}
