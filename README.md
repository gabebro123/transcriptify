YouTube Transcript Dart 🎥📝
youtube_transcript_dart is a Dart package that fetches YouTube video transcripts directly from YouTube without requiring API keys. It allows you to retrieve both auto-generated and manually created transcripts in multiple languages.

🌟 Features
✔ Fetch YouTube video transcripts without an API key
✔ Support for multiple languages
✔ Handles auto-generated and manually created captions
✔ Provides structured JSON output
✔ Error handling for unavailable or invalid transcripts

🚀 Installation
Using dart pub
Run the following command to install the package:

\\\sh
Copy
Edit
dart pub add youtube_transcript_dart
Adding to pubspec.yaml
Alternatively, add this to your pubspec.yaml:

yaml
Copy
Edit
dependencies:
  youtube_transcript_dart: ^1.0.0
📌 Usage
Fetching a Transcript for a Single Video
dart
Copy
Edit
import 'package:youtube_transcript_dart/youtube_transcript_dart.dart';

void main() async {
  try {
    final transcript = await YouTubeTranscriptApi.getTranscript('dQw4w9WgXcQ');
    print(transcript);
  } catch (e) {
    print("Error: $e");
  }
}
Fetching Transcripts for Multiple Videos
dart
Copy
Edit
import 'package:youtube_transcript_dart/youtube_transcript_dart.dart';

void main() async {
  try {
    final transcripts = await YouTubeTranscriptApi.getTranscripts(
      ['dQw4w9WgXcQ', 'LXb3EKWsInQ'],
    );
    print(transcripts);
  } catch (e) {
    print("Error: $e");
  }
}
Handling Errors
The package throws exceptions for various error cases:

dart
Copy
Edit
try {
  final transcript = await YouTubeTranscriptApi.getTranscript('INVALID_VIDEO_ID');
} catch (e) {
  print("Failed to fetch transcript: $e");
}
🛠️ Formatting Options
Converting to JSON
dart
Copy
Edit
import 'package:youtube_transcript_dart/src/transcript_formatters.dart';

void main() async {
  final transcript = await YouTubeTranscriptApi.getTranscript('dQw4w9WgXcQ');
  final jsonTranscript = formatTranscriptToJson(transcript);
  print(jsonTranscript);
}
Converting to WebVTT
dart
Copy
Edit
import 'package:youtube_transcript_dart/src/transcript_formatters.dart';

void main() async {
  final transcript = await YouTubeTranscriptApi.getTranscript('dQw4w9WgXcQ');
  final webVTT = formatTranscriptToWebVTT(transcript);
  print(webVTT);
}
📌 Supported Exceptions
This package provides exception handling for the following cases:

Exception	Description
InvalidVideoIdException	The video ID is invalid.
NoTranscriptFoundException	No transcript was found for the given video.
TooManyRequestsException	YouTube has blocked access due to excessive requests.
TranscriptsDisabledException	Transcripts are disabled for this video.
TranscriptException	A general exception for transcript retrieval failures.
📜 License
This project is licensed under the MIT License.
See the LICENSE file for more details.

👥 Contributing
We welcome contributions!
If you find a bug or have an idea for improvement, feel free to open an issue or submit a pull request.

Steps to Contribute
Fork this repository.
Create a new branch (feature-new-transcript-format).
Commit your changes.
Push to your fork and create a pull request.
🔗 Links
📦 Package on pub.dev: youtube_transcript_dart
📖 Dart Documentation: Dart Docs
