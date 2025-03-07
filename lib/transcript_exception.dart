class TranscriptException implements Exception {
  final String message;
  TranscriptException(this.message);

  @override
  String toString() => 'TranscriptException: $message';
}

class NoTranscriptFound extends TranscriptException {
  NoTranscriptFound(String videoId) : super('No transcript found for video ID: $videoId');
}

class InvalidVideoId extends TranscriptException {
  InvalidVideoId(String videoId) : super('Invalid video ID: $videoId');
}

class TooManyRequests extends TranscriptException {
  TooManyRequests(String videoId) : super('Too many requests for video ID: $videoId');
}

class VideoUnavailable extends TranscriptException {
  VideoUnavailable(String videoId) : super('Video unavailable for video ID: $videoId');
}

class TranscriptsDisabled extends TranscriptException {
  TranscriptsDisabled(String videoId) : super('Transcripts are disabled for video ID: $videoId');
}

class YouTubeRequestFailed implements Exception {
  final int statusCode;
  final String videoId;

  YouTubeRequestFailed(this.statusCode, this.videoId);

  @override
  String toString() => 'YouTubeRequestFailed: Request failed with status code $statusCode for video ID $videoId';
}
