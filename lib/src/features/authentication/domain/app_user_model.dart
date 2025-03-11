// ignore_for_file: public_member_api_docs, sort_constructors_first
typedef UserId = String;

/// User model for the application.
class AppUser {
  const AppUser({
    required this.uid,
    this.email,
    this.emailVerified = false,
  });

  /// Unique identifier for the user.
  final UserId uid;
  /// Email address for the user.
  final String? email;
  /// Whether the email address has been verified.
  final bool emailVerified;

  ///Compares the current instance with the [other] instance.
  @override
  bool operator ==(covariant AppUser other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.email == email &&
        other.emailVerified == emailVerified;
  }

  /// Generates a hash code for the current instance.
  @override
  int get hashCode => uid.hashCode ^ email.hashCode ^ emailVerified.hashCode;

  /// Returns a string representation of the current instance.
  @override
  String toString() =>
      'AppUser(uid: $uid, email: $email, emailVerified: $emailVerified)';
}
