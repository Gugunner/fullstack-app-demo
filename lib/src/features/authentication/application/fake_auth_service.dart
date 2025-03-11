import 'package:collection/collection.dart';
import 'package:piix_mobile/src/features/authentication/application/auth_service.dart';
import 'package:piix_mobile/src/features/authentication/domain/authentication_model_barrel_file.dart';
import 'package:piix_mobile/src/network/app_exception.dart';
import 'package:piix_mobile/src/utils/delay.dart';
import 'package:piix_mobile/src/utils/fake_memory_store.dart';
import 'package:piix_mobile/src/utils/verification_type.dart';

/// A fake implementation of [AuthService] for testing purposes.
class FakeAuthService implements AuthService {
  FakeAuthService({this.addDelay = false});

  final bool addDelay;

  /// A [FakeMemoryStore] to store the current user.
  final _authState = FakeMemoryStore<AppUser?>(null);

  /// Emits the current user when it changes.
  @override
  Stream<AppUser?> authStateChange() => _authState.stream;

  /// Emits the current user when the id token changes.
  @override
  Stream<AppUser?> idTokenChanges() {
    // If the current user is not null and the email is verified,
    if (_authState.value != null && _authState.value!.emailVerified) {
      // Emit the current user.
      return _authState.stream;
    } else {
      // Otherwise, emit null.
      return Stream.value(null);
    }
  }

  ///A list where all the users are stored.
  final List<FakeAppUser> _users = [];
  final Map<String, String> _codes = {};

  /// Returns a list [users].
  List<FakeAppUser> getUsersList() => _users;

  /// Returns the list of [codes].
  Map<String, String> getCodesTable() => _codes;

  /// Returns the current user.
  @override
  AppUser? get currentUser => _authState.value;

  /// Sends a verification code to the user's email.
  @override
  Future<void> sendVerificationCodeByEmail(
    String email,
    String languageCode,
    VerificationType verificationType,
  ) {
    if (addDelay) {
      delay(addDelay);
    }
    //Lookup the user by the email
    final user = _users.firstWhereOrNull((u) => u.email == email);
    //If there is no user but a login attempt is made then throw an
    //EmailNotFoundException
    if (user == null && verificationType == VerificationType.login) {
      throw EmailNotFoundException();
    }
    //If there is already a user but a register attempt is made then throw an
    //EmailAlreadyExistsException
    if (user != null && verificationType == VerificationType.register) {
      throw EmailAlreadyExistsException();
    }
    //Add the email and verification code to
    //[_codes]
    _addVerificationToCodes(email, '123456');
    //Return an empty value and exit the function.
    return Future.value();
  }

  /// Creates an account with the email and verification code.
  @override
  Future<void> createAccountWithEmailAndVerificationCode(
    String email,
    String verificationCode,
    String languageCode,
  ) {
    if (addDelay) {
      delay(addDelay);
    }
    //Lookup the user by the email
    final user = _users.firstWhereOrNull((u) => u.email == email);
    //If a user is already found throw a EmailAlreadyExistsException
    //* This specific case only happens during unit tests, whe doing it through
    //* the app a user will always need to first check by executing
    //* [sendVerificationCodeByEmail]
    if (user != null) {
      throw EmailAlreadyExistsException();
    }
    //Obtain the uid from the email
    final uid = _toUidOrEmail(email);
    //If there are no prior codes then throw an UnkownErrorException
    if (_codes.isEmpty) {
      _authState.value = null;
      throw UnknownErrorException('there are no codes stored');
    }
    //Check the verification code to see if it matches
    if (_codes[email] != verificationCode) {
      //If the verification code is incorrect, set the current user to null
      //and throw an IncorrectVerificationCodeException
      _authState.value = null;
      throw IncorrectVerificationCodeException();
    }
    //If the verification code is correct, create the new user.
    _createNewUser(email, uid, verificationCode);
    //Return an empty value and exit the function.
    return Future.value();
  }

  /// Signs in with the email and verification code.
  @override
  Future<void> signInWithEmailAndVerificationCode(
    String email,
    String verificationCode,
    String languageCode,
  ) {
    if (addDelay) {
      delay(addDelay);
    }
    //Lookup the user by the email
    final user = _users.firstWhereOrNull((u) => u.email == email);
    //If a user is not found throw a EmailNotFoundException
    //* This specific case only happens during unit tests, whe doing it through
    //* the app a user will always need to first check by executing
    //* [sendVerificationCodeByEmail]
    if (user == null) {
      throw EmailNotFoundException();
    }
    //If there are no prior codes then throw an UnkownErrorException
    if (_codes.isEmpty) {
      _authState.value = null;
      throw UnknownErrorException('there are no codes stored');
    }
    //Check the verification code to see if it matches
    if (_codes[email] != verificationCode) {
      //If the verification code is incorrect, set the current user to null
      //and throw an IncorrectVerificationCodeException
      _authState.value = null;
      throw IncorrectVerificationCodeException();
    }
    //If the verification code is correct, log in the user.
    _Login(email, user);
    //Return an empty value and exit the function.
    return Future.value();
  }

  /// Signs out the current user.
  @override
  Future<void> signOut() {
    if (addDelay) {
      delay(addDelay);
    }
    //Set the current user to null.
    _authState.value = null;
    return Future.value();
  }

  /// Disposes the [FakeMemoryStore] instance.
  void dispose() => _authState.dispose();

  /// Adds the [email] as key and [verificationCode] as value
  /// to the [_codes] hashmap.
  void _addVerificationToCodes(String email, String verificationCode) {
    if (_codes.containsKey(email)) return;
    _codes[email] = verificationCode;
  }

  /// Create a new [FakeAppUser] and adds it
  /// to [_users].
  void _createNewUser(
    String email,
    String uid,
    String verificationCode,
  ) {
    final user = FakeAppUser(
      uid: uid,
      email: email,
      emailVerified: true,
      verificationCode: verificationCode,
    );
    _users.add(user);
    //Finally log in the user.
    _Login(email, user);
  }

  ///Logs the user in by assigning [user] to the [_authState.value].
  ///It also removes the key value pair from [_codes].
  void _Login(String email, FakeAppUser user) {
    //Remove the attributed from _codes by using the email key
    _codes.remove(email);
    //Set the current user to the user.
    _authState.value = user;
  }

  /// Converts a uid to an email by reversing it and viceversa.
  String _toUidOrEmail(String str) => str.split('').reversed.join();
}
