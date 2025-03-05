import 'package:test/test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:youtube_transcript_dart/youtube_transcript_dart.dart';
import 'package:youtube_transcript_dart/src/transcript_exception.dart';  // Corrected import path
import 'youtube_transcript_dart_test.mocks.dart';  // Ensure this import is correct

@GenerateMocks([YouTubeTranscriptApi])
void main() {
  late MockYouTubeTranscriptApi mockApi;

  setUp(() {
    mockApi = MockYouTubeTranscriptApi();
  });

  test("YouTubeTranscriptApi.getTranscript returns transcript", () async {
    when(mockApi.getTranscript(any)).thenAnswer((_) async => [
      {"text": "Hello", "start": 0.0, "duration": 2.0},
      {"text": "This is a test.", "start": 2.5, "duration": 3.0}
    ]);

    final transcript = await mockApi.getTranscript("dQw4w9WgXcQ");

    expect(transcript, isA<List<Map<String, dynamic>>>());
    expect(transcript.isNotEmpty, true);
    expect(transcript[0]["text"], equals("Hello"));
    expect(transcript[1]["text"], equals("This is a test."));
  });

  test("YouTubeTranscriptApi.getTranscripts returns multiple transcripts", () async {
    when(mockApi.getTranscripts(["dQw4w9WgXcQ", "LXb3EKWsInQ"])).thenAnswer((_) async => {
      "dQw4w9WgXcQ": [
        {"text": "Hello", "start": 0.0, "duration": 2.0}
      ],
      "LXb3EKWsInQ": [
        {"text": "This is another test.", "start": 1.0, "duration": 2.5}
      ]
    });

    final transcripts = await mockApi.getTranscripts(["dQw4w9WgXcQ", "LXb3EKWsInQ"]);

    expect(transcripts, isNotEmpty);
    expect(transcripts["dQw4w9WgXcQ"], isNotEmpty);
    expect(transcripts["LXb3EKWsInQ"], isNotEmpty);
  });

  test("Handles invalid video ID", () async {
    when(mockApi.getTranscript("INVALID_VIDEO_ID"))
        .thenThrow(TranscriptException("Invalid video ID"));

    expect(
      () async => await mockApi.getTranscript("INVALID_VIDEO_ID"),
      throwsA(isA<TranscriptException>()),
    );
  });

  test("Handles video with no captions", () async {
    when(mockApi.getTranscript("NO_CAPTIONS_VIDEO_ID"))
        .thenThrow(NoTranscriptFound("NO_CAPTIONS_VIDEO_ID"));

    expect(
      () async => await mockApi.getTranscript("NO_CAPTIONS_VIDEO_ID"),
      throwsA(isA<NoTranscriptFound>()),
    );
  });
}
