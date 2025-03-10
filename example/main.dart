import 'package:youtube_transcript_dart/youtube_transcript_dart.dart';

void main() async {
  String videoId = "dQw4w9WgXcQ"; // Replace with any YouTube video ID

  try {
    final transcript = await YouTubeTranscriptApi().getTranscript(videoId);
    for (var entry in transcript) {
      print("${entry["start"]}s: ${entry["text"]}");
    }
  } catch (e) {
    print("Error fetching transcript: $e");
  }
}
