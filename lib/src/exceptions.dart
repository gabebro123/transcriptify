class TranscriptException implements Exception {
  final String message;

  TranscriptException(this.message);

  @override
  String toString() => 'TranscriptException: $message';
}

class NoTranscriptFound extends TranscriptException {
  NoTranscriptFound(String videoId) : super("No transcript found for video: $videoId");
}

class InvalidVideoId extends TranscriptException {
  InvalidVideoId(String videoId) : super("Invalid video ID: $videoId");
}

class TooManyRequests extends TranscriptException {
  TooManyRequests(String videoId) : super("Too many requests for video: $videoId");
}

class VideoUnavailable extends TranscriptException {
  VideoUnavailable(String videoId) : super("Video unavailable: $videoId");
}

class TranscriptsDisabled extends TranscriptException {
  TranscriptsDisabled(String videoId) : super("Transcripts disabled for video: $videoId");
}

class YouTubeRequestFailed implements Exception {
  final int statusCode;
  final String videoId;

  YouTubeRequestFailed(this.statusCode, this.videoId);

  @override
  String toString() => 'YouTubeRequestFailed: Request failed with status code $statusCode for video ID $videoId';
}
