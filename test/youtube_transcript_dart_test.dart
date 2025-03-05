import 'package:test/test.dart';
import 'package:youtube_transcript_dart/src/exceptions.dart';  // ✅ Add this
import '../lib/youtube_transcript_dart_base.dart';

void main() {
  test('Fetch transcript for a valid video ID', () async {
    final transcript = await YouTubeTranscriptApi.getTranscript("dQw4w9WgXcQ");
    expect(transcript, isNotEmpty);
  });

  test('Fetch transcripts for multiple video IDs', () async {
    final transcripts = await YouTubeTranscriptApi.getTranscripts(
      ["dQw4w9WgXcQ", "SVqN_FixG0M"],
    );
    expect(transcripts, isNotEmpty);
  });

  test('Handle invalid video ID', () async {
    expect(
      () async => await YouTubeTranscriptApi.getTranscript("INVALID_VIDEO_ID"),
      throwsA(isA<NoTranscriptFound>()),  // ✅ Correct class name
    );
  });

  test('Handle video with no captions', () async {
    expect(
      () async => await YouTubeTranscriptApi.getTranscript("NO_CAPTIONS_VIDEO_ID"),
      throwsA(isA<TranscriptException>()),  // ✅ Correct class name
    );
  });
}
