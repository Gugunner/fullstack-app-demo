import 'package:json_annotation/json_annotation.dart';

import 'package:piix_mobile/src/features/authentication/domain/app_user_model.dart';

part 'account_user_model.g.dart';

typedef InvitationCode = String;

enum Gender {
  MALE,
  FEMALE,
}

///Verification status for the user's documentation
///that changes as the verificaiton process advance.
enum VerificationStatus {
  //If the user has not uploaded any documentation but has created an account.
  IDLE,
  //If the user uploads documentation for verification.
  PENDING,
  //If the user documentation is sent for manual revision
  IN_REVISION,
  //If the user documentation is approved manually.
  PREAPPROVED,
  //If the user documentation is approved by the system.
  APPROVED,
  //If the user documentation is rejected.
  REJECTED,
}

///The applied user model for the application.
///
///Used for the user's account information.
@JsonSerializable(
  createToJson: false,
)
class AccountUser extends AppUser {
  AccountUser({
    required super.uid,
    required super.email,
    required super.emailVerified,
    required this.name,
    required this.firstLastName,
    this.middleName,
    this.secondLastName,
    required this.gender,
    required this.dateOfBirth,
    required this.documentation,
    this.invitationCode,
    this.verificationStatus = VerificationStatus.IDLE,
  });

  /// User's name.
  final String name;

  /// User's first last name.
  final String firstLastName;

  /// User's middle name.
  final String? middleName;

  /// User's second last name.
  final String? secondLastName;

  /// User's gender
  final Gender gender;

  /// User's date of birth.
  final DateTime dateOfBirth;

  /// User's documentation.
  final Map<String, dynamic> documentation;

  /// User's invitation code which links to the user to a community
  /// or another user's group.
  final InvitationCode? invitationCode;

  /// User's verification status that changes during
  /// the documentation verification process.
  final VerificationStatus verificationStatus;

  AccountUser copyWith({
    UserId? uid,
    String? email,
    bool? emailVerified,
    String? name,
    String? firstLastName,
    String? middleName,
    String? secondLastName,
    Gender? gender,
    DateTime? dateOfBirth,
    Map<String, dynamic>? documentation,
    InvitationCode? invitationCode,
    VerificationStatus? verificationStatus,
  }) {
    return AccountUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      emailVerified: emailVerified ?? this.emailVerified,
      name: name ?? this.name,
      firstLastName: firstLastName ?? this.firstLastName,
      middleName: middleName ?? this.middleName,
      secondLastName: secondLastName ?? this.secondLastName,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      documentation: documentation ?? this.documentation,
      invitationCode: invitationCode ?? this.invitationCode,
      verificationStatus: verificationStatus ?? this.verificationStatus,
    );
  }

  factory AccountUser.fromJson(Map<String, dynamic> json) =>
      _$AccountUserFromJson(json);

  @override
  String toString() {
    return 'AccountUser(name: $name, firstLastName: $firstLastName, '
        'middleName: $middleName, secondLastName: $secondLastName, '
        'gender: $gender, dateOfBirth: $dateOfBirth, '
        'documentation: $documentation, invitationCode: $invitationCode, '
        'verificationStatus: $verificationStatus)';
  }

  /// Returns a new [_Documentation] instance from the [documentation] map.
  _Documentation getDocumentationFromMap() =>
      _Documentation.fromMap(documentation);
}

///Contains all the paths for the user's documentation images stored.
class _Documentation {
  const _Documentation({
    required this.officialIdImagePath,
    required this.selfieImagePath,
  });

  /// Path to the user's official ID image.
  final String officialIdImagePath;

  /// Path to the user's selfie image.
  final String selfieImagePath;

  _Documentation copyWith({
    String? officialIdImagePath,
    String? selfieImagePath,
  }) {
    return _Documentation(
      officialIdImagePath: officialIdImagePath ?? this.officialIdImagePath,
      selfieImagePath: selfieImagePath ?? this.selfieImagePath,
    );
  }

  ///Creates a new [_Documentation] instance from the [map].
  factory _Documentation.fromMap(Map<String, dynamic> map) {
    return _Documentation(
      officialIdImagePath: map['officialIdImagePath'] as String,
      selfieImagePath: map['selfieImagePath'] as String,
    );
  }

  @override
  String toString() =>
      '_Documentation(officialIdImagePath: $officialIdImagePath, '
      'selfieImagePath: $selfieImagePath)';

  ///Compares the current instance with the [other] instance.
  @override
  bool operator ==(covariant _Documentation other) {
    if (identical(this, other)) return true;

  return other.officialIdImagePath == officialIdImagePath &&
        other.selfieImagePath == selfieImagePath;
  }

  /// Generates a hash code for the current instance.
  @override
  int get hashCode => officialIdImagePath.hashCode ^ selfieImagePath.hashCode;
}
