import 'package:firebase_auth/firebase_auth.dart';
import 'package:piix_mobile/src/features/authentication/domain/app_user_model.dart';

/// Firebase user model for the application.
class FirebaseAppUser implements AppUser {
  FirebaseAppUser(this._user);
  /// Firebase user instance.
  final User _user;

  ///Gets the unique identifier for the user.
  @override
  UserId get uid => _user.uid;

  ///Gets the email address for the user.
  @override
  String? get email => _user.email;

  ///Gets whether the email address has been verified.
  @override
  bool get emailVerified => _user.emailVerified;
}
