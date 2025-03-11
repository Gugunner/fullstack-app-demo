import 'dart:io';
import 'package:dio/dio.dart';

///The base class for all exceptions in the application.
///
///This class is used to define custom exceptions that can be thrown
///and caught in the application.
sealed class AppException implements Exception {
  const AppException({
    required this.errorCode,
    required this.codeNumber,
    required this.message,
    required this.prefix,
    required this.statusCode,
    required this.name,
    this.status,
    this.stackTrace,
  });

  ///A unique identifier for the exception.
  final String errorCode;

  ///A unique 6 digit number for the exception.
  final String codeNumber;

  ///A human-readable message for the exception.
  final String message;

  ///A unique identifier of the module throwing the exception.
  final String prefix;

  ///The [HttpStatus] for the exception.
  final int statusCode;

  ///The name of the exception.
  final String name;

  ///The status of the exception based on the grpc status codes [https://github.com/grpc/grpc/blob/master/doc/statuscodes.md].
  final String? status;

  ///The stack trace of the exception.
  final StackTrace? stackTrace;

  @override
  String toString() {
    return '$name - $codeNumber: -> $message';
  }
}

///An exception thrown when the email address already exists.
class EmailAlreadyExistsException extends AppException {
  EmailAlreadyExistsException()
      : super(
          errorCode: 'email-already-exists',
          codeNumber: '2001',
          message: 'The email address is already in use by another account.',
          prefix: 'piix-auth',
          statusCode: HttpStatus.conflict,
          name: 'EMAIL_ALREADY_EXISTS',
        );
}

///An exception thrown when the email address is not found.
class EmailNotFoundException extends AppException {
  EmailNotFoundException()
      : super(
          errorCode: 'email-not-found',
          codeNumber: '2002',
          message: 'The email address is not found.',
          prefix: 'piix-auth',
          statusCode: HttpStatus.notFound,
          name: 'EMAIL_NOT_FOUND',
        );
}

///An exception thrown when the verification code is incorrect.
class IncorrectVerificationCodeException extends AppException {
  IncorrectVerificationCodeException()
      : super(
          errorCode: 'incorrect-verification-code',
          codeNumber: '2003',
          message: 'The verification code is incorrect.',
          prefix: 'piix-auth',
          statusCode: HttpStatus.conflict,
          name: 'INCORRECT_VERIFICATION_CODE',
          status: 'ABORTED',
        );
}

///An exception thrown when the email could not be sent.
class EmailNotSentException extends AppException {
  EmailNotSentException()
      : super(
          errorCode: 'email-not-sent',
          codeNumber: '3003',
          message: 'The email could not be sent.',
          prefix: 'piix-functions',
          statusCode: HttpStatus.internalServerError,
          name: 'EMAIL_NOT_SENT',
        );
}

///An exception thrown when the custom token could not be obtained.
class CustomTokenFailedException extends AppException {
  CustomTokenFailedException()
      : super(
          errorCode: 'custom-token-failed',
          codeNumber: '2004',
          message: 'Failed to obtain custom token.',
          prefix: 'piix-auth',
          statusCode: HttpStatus.notImplemented,
          name: 'CUSTOM_TOKEN_FAILED',
        );
}

///An exception thrown when an unknown error occurs.
class UnknownErrorException extends AppException {
  UnknownErrorException(Object error)
      : super(
          errorCode: 'unknown-error',
          codeNumber: 'NA',
          message: 'An unknown error occurred - ${error.toString()}.',
          prefix: 'piix-network',
          statusCode: HttpStatus.internalServerError,
          name: 'UNKNOWN_ERROR',
        );
}

///Builds a custom exception from a DioException.
///and handles the exception based on the error code.
class CustomAppException extends AppException {
  CustomAppException({
    required String errorCode,
    required String codeNumber,
    required String message,
    required String prefix,
    required int statusCode,
    required String name,
    String? status,
    StackTrace? stackTrace,
  }) : super(
          errorCode: errorCode,
          codeNumber: codeNumber,
          message: message,
          prefix: prefix,
          statusCode: statusCode,
          name: name,
          status: status,
          stackTrace: stackTrace,
        );

  ///Builds a custom exception from a DioException.
  factory CustomAppException._fromDioException(DioException dioException) {
    //TODO: Log the error to a logging service
    return CustomAppException(
      errorCode: 'dio-exception',
      codeNumber: 'NA',
      message: 'An error occurred while processing the request.',
      prefix: 'piix-network',
      statusCode:
          dioException.response?.statusCode ?? HttpStatus.internalServerError,
      name: 'DIO_EXCEPTION',
      status: dioException.toString().split(' ')[1],
      stackTrace: dioException.stackTrace,
    );
  }

  ///Builds a custom exception that is either a defined [AppException]
  ///class or a custom exception that contains details.
  static AppException fromModulesException(DioException dioException) {
    final data = dioException.response?.data;
    //Check if the response data is null or does not contain the details
    if (data == null ||
        data?['details'] == null ||
        data?['details']?['errorCode'] == null) {
      return CustomAppException._fromDioException(dioException);
    }
    //Get the details from the response data
    final details = data['details'] as Map<String, dynamic>;
    //Check if the error code is a defined [AppException] class
    final definedAppException = fromErrorCode(details['errorCode'] as String);
    //Return the defined [AppException] class if it is not null
    if (definedAppException != null) {
      return definedAppException;
    }
    //Return a custom exception with the details
    return CustomAppException(
      name: details['name'] as String,
      codeNumber: details['codeNumber'] as String,
      prefix: details['prefix'] as String,
      errorCode: details['errorCode'] as String,
      message: data['message'] as String,
      status: data['status'] as String?,
      stackTrace: dioException.stackTrace,
      statusCode: dioException.response!.statusCode!,
    );
  }

  ///Builds a custom exception from an error code.
  static AppException? fromErrorCode(String errorCode) {
    switch (errorCode) {
      case 'email-already-exists':
        return EmailAlreadyExistsException();
      case 'email-not-found':
        return EmailNotFoundException();
      case 'incorrect-verification-code':
        return IncorrectVerificationCodeException();
      case 'custom-token-failed':
        return CustomTokenFailedException();
      default:
        return null;
    }
  }
}
