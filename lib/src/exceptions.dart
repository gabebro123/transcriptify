/// Base class for all transcript-related exceptions.
class TranscriptException implements Exception {
  /// Creates a new [TranscriptException] with the given [message].
  TranscriptException(this.message);

  /// The error message associated with this exception.
  final String message;

  @override
  String toString() => 'TranscriptException: $message';
}

/// Exception thrown when no transcript is found for a given video ID.
class NoTranscriptFound extends TranscriptException {
  /// Creates a new [NoTranscriptFound] exception with the given [videoId].
  NoTranscriptFound(String videoId)
      : super('No transcript found for video ID: $videoId');
}

/// Exception thrown when an invalid video ID is provided.
class InvalidVideoId extends TranscriptException {
  /// Creates a new [InvalidVideoId] exception with the given [videoId].
  InvalidVideoId(String videoId) : super('Invalid video ID: $videoId');
}

/// Exception thrown when too many requests are made for a given video ID.
class TooManyRequests extends TranscriptException {
  /// Creates a new [TooManyRequests] exception with the given [videoId].
  TooManyRequests(String videoId)
      : super('Too many requests for video ID: $videoId');
}

/// Exception thrown when a video is unavailable for a given video ID.
class VideoUnavailable extends TranscriptException {
  /// Creates a new [VideoUnavailable] exception with the given [videoId].
  VideoUnavailable(String videoId)
      : super('Video unavailable for video ID: $videoId');
}

/// Exception thrown when transcripts are disabled for a given video ID.
class TranscriptsDisabled extends TranscriptException {
  /// Creates a new [TranscriptsDisabled] exception with the given [videoId].
  TranscriptsDisabled(String videoId)
      : super('Transcripts are disabled for video ID: $videoId');
}

/// Exception thrown when a YouTube request fails with a given status code.
class YouTubeRequestFailed extends TranscriptException {
  /// Creates a new [YouTubeRequestFailed] exception with the given [statusCode] and [videoId].
  YouTubeRequestFailed(this.statusCode, this.videoId)
      : super(
            'Request failed with status code $statusCode for video ID $videoId');

  /// The status code of the failed request.
  final int statusCode;

  /// The video ID associated with the failed request.
  final String videoId;

  @override
  String toString() =>
      'YouTubeRequestFailed: Request failed with status code $statusCode for video ID $videoId';
}
