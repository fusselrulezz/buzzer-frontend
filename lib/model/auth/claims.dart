import "package:collection/collection.dart";

/// Represents a collection of claims, which are key-value pairs used for
/// authentication and authorization purposes.
class Claims extends DelegatingMap<String, dynamic> {
  /// Initializes a new [Claims] instance with the provided map of claims.
  Claims(super.base);
}
