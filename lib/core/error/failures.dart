/// Base class for all failures in the application
///
/// Using sealed class to allow exhaustive pattern matching
sealed class Failure {
  final String message;
  
  const Failure(this.message);
}

/// Failure that occurs when making server requests
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Failure that occurs with cached data
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}
