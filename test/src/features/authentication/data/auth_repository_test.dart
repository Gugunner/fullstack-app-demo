import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:piix_mobile/src/features/authentication/data/auth_repository.dart';
import 'package:piix_mobile/src/network/app_dio.dart';
import 'package:piix_mobile/src/network/app_exception.dart';
import 'package:piix_mobile/src/utils/verification_type.dart';

import '../../../mocks.dart';

void main() {
  const testEmail = 'email@example.com';
  const testLanguageCode = 'en';
  const testVerificationType = VerificationType.login;
  const testVerificationCode = '123456';
  String? path;
  RequestOptions? options;
  final mockDio = MockDio();
  final mockAppDio = AppDio(mockDio);
  const expectedCustomToken = 'fake_token';

  AuthRepository makeAuthRepository() => AuthRepository(mockAppDio);

  group('Auth Repository Send Verification Code By Email tests', () {
    const expectedResponse = {'code': 0};

    setUp(() {
      reset(mockDio);
    });

    setUpAll(() {
      path = '/sendVerificationCodeRequest';
      options = RequestOptions(path: path!);
    });

    test(
      '''WHEN a valid email, languageCode and verificationType is sent
    THEN the response will have a status code 200 
    AND a { code: 0 } response body''',
      () async {
        when(() => mockDio.post(path!, data: {
              'email': testEmail,
              'languageCode': testLanguageCode,
              'verificationType': testVerificationType.name,
            })).thenAnswer((_) async => Response(
              data: expectedResponse,
              statusCode: HttpStatus.ok,
              requestOptions: options!,
            ));
        expect(
            await makeAuthRepository().sendVerificationCodeByEmail(
              testEmail,
              testLanguageCode,
              testVerificationType,
            ),
            isA<Response>().having((r) => r.data, 'data', expectedResponse));
        verify(() => mockDio.post(
              path!,
              data: {
                'email': testEmail,
                'languageCode': testLanguageCode,
                'verificationType': testVerificationType.name,
              },
            )).called(1);
      },
    );
    test('''WHEN a valid email, languageCode and verificationType is sent
    AND the verificationType is register
    AND the email is already used by an account
    THEN the response will be an EmailAlreadyExistsException''', () async {
      when(() => mockDio.post(path!, data: {
            'email': testEmail,
            'languageCode': testLanguageCode,
            'verificationType': testVerificationType.name,
          })).thenThrow(DioException(
        requestOptions: options!,
        response: Response(
          requestOptions: options!,
          data: {
            'details': {
              'name': 'EMAIL_ALREADY_EXISTS',
              'codeNumber': '2001',
              'prefix': 'piix-auth',
              'errorCode': 'email-already-exists',
            },
            'message': 'The email is already in use.',
            'status': 'ALREADY_EXISTS',
          },
          statusCode: HttpStatus.conflict,
        ),
      ));
      expect(
        () async => makeAuthRepository().sendVerificationCodeByEmail(
          testEmail,
          testLanguageCode,
          testVerificationType,
        ),
        throwsA(
          isA<EmailAlreadyExistsException>()
              .having((e) => e.errorCode, 'errorCode', 'email-already-exists')
              .having((e) => e.codeNumber, 'codeNumber', '2001')
              .having((e) => e.statusCode, 'statusCode', HttpStatus.conflict),
        ),
      );
      verify(() => mockDio.post(path!, data: {
            'email': testEmail,
            'languageCode': testLanguageCode,
            'verificationType': testVerificationType.name,
          })).called(1);
    });
    test('''WHEN a valid email, languageCode and verificationType is sent
    AND the verificationType is login
    AND the email is not used by an account
    THEN the response will be an EmailNotFoundException''', () async {
      when(() => mockDio.post(path!, data: {
            'email': testEmail,
            'languageCode': testLanguageCode,
            'verificationType': testVerificationType.name,
          })).thenThrow(DioException(
        requestOptions: options!,
        response: Response(
          requestOptions: options!,
          data: {
            'details': {
              'name': 'EMAIL_NOT_FOUND',
              'codeNumber': '2002',
              'prefix': 'piix-auth',
              'errorCode': 'email-not-found'
            },
            'message': 'The email was not found.',
            'status': 'NOT_FOUND'
          },
          statusCode: HttpStatus.notFound,
        ),
      ));
      expect(
        () async => makeAuthRepository().sendVerificationCodeByEmail(
          testEmail,
          testLanguageCode,
          testVerificationType,
        ),
        throwsA(
          isA<EmailNotFoundException>()
              .having((e) => e.errorCode, 'errorCode', 'email-not-found')
              .having((e) => e.codeNumber, 'codeNumber', '2002')
              .having((e) => e.statusCode, 'statusCode', HttpStatus.notFound),
        ),
      );
      verify(() => mockDio.post(path!, data: {
            'email': testEmail,
            'languageCode': testLanguageCode,
            'verificationType': testVerificationType.name,
          })).called(1);
    });
    test('''WHEN a valid email, languageCode and verificationType is sent 
    AND the email cannot be sent
    THEN the response will be an CustomAppException
    AND the CustomAppException status code will be 500
    AND the errorCode will be "email-not-sent"
    AND the codeNumber will be "3003"''', () async {
      when(() => mockDio.post(path!, data: {
            'email': testEmail,
            'languageCode': testLanguageCode,
            'verificationType': testVerificationType.name,
          })).thenThrow(DioException(
        requestOptions: options!,
        response: Response(
          requestOptions: options!,
          data: {
            'details': {
              'name': 'EMAIL_NOT_SENT',
              'codeNumber': '3003',
              'prefix': 'piix-functions',
              'errorCode': 'email-not-sent',
            },
            'message': 'Could not send the verification code to the email.',
            'status': 'ABORTED',
          },
          statusCode: HttpStatus.internalServerError,
        ),
      ));
      expect(
        () async => makeAuthRepository().sendVerificationCodeByEmail(
          testEmail,
          testLanguageCode,
          testVerificationType,
        ),
        throwsA(
          isA<CustomAppException>()
              .having((e) => e.errorCode, 'errorCode', 'email-not-sent')
              .having((e) => e.codeNumber, 'codeNumber', '3003')
              .having((e) => e.statusCode, 'statusCode',
                  HttpStatus.internalServerError),
        ),
      );
      verify(() => mockDio.post(path!, data: {
            'email': testEmail,
            'languageCode': testLanguageCode,
            'verificationType': testVerificationType.name,
          })).called(1);
    });

    test('''WHEN a valid email, languageCode and verificationType is sent  
    AND the code cannot be saved
    THEN the response will be a CustomAppException
    AND the CustomAppException status code will be 500
    AND the errorCode will be "document-not-added"
    AND the codeNumber will be "0101"''', () async {
      when(() => mockDio.post(path!, data: {
            'email': testEmail,
            'languageCode': testLanguageCode,
            'verificationType': testVerificationType.name,
          })).thenThrow(DioException(
        requestOptions: options!,
        response: Response(
          requestOptions: options!,
          data: {
            'details': {
              'name': 'DOCUMENT_NOT_ADDED',
              'codeNumber': '0101',
              'prefix': 'store',
              'errorCode': 'document-not-added',
            },
            'message': 'Could not store the verification code.',
            'status': 'ABORTED',
          },
          statusCode: HttpStatus.internalServerError,
        ),
      ));
      expect(
        () async => makeAuthRepository().sendVerificationCodeByEmail(
          testEmail,
          testLanguageCode,
          testVerificationType,
        ),
        throwsA(
          isA<CustomAppException>()
              .having((e) => e.errorCode, 'errorCode', 'document-not-added')
              .having((e) => e.codeNumber, 'codeNumber', '0101')
              .having((e) => e.statusCode, 'statusCode',
                  HttpStatus.internalServerError),
        ),
      );
      verify(() => mockDio.post(path!, data: {
            'email': testEmail,
            'languageCode': testLanguageCode,
            'verificationType': testVerificationType.name,
          })).called(1);
    });

    test('''WHEN a valid email, languageCode and verificationType is sent 
    AND an unknown DioException occurs
    THEN the response will be a CustomAppException
    AND the CustomAppException status code will be 500
    AND the errorCode will be "dio-exception"
    AND the codeNumber will be "NA"''', () async {
      when(() => mockDio.post(path!, data: {
            'email': testEmail,
            'languageCode': testLanguageCode,
            'verificationType': testVerificationType.name,
          })).thenThrow(DioException(
        requestOptions: options!,
      ));
      expect(
        () async => makeAuthRepository().sendVerificationCodeByEmail(
          testEmail,
          testLanguageCode,
          testVerificationType,
        ),
        throwsA(
          isA<CustomAppException>()
              .having((e) => e.errorCode, 'errorCode', 'dio-exception')
              .having((e) => e.codeNumber, 'codeNumber', 'NA')
              .having((e) => e.statusCode, 'statusCode',
                  HttpStatus.internalServerError),
        ),
      );
      verify(() => mockDio.post(path!, data: {
            'email': testEmail,
            'languageCode': testLanguageCode,
            'verificationType': testVerificationType.name,
          })).called(1);
    });

    test('''WHEN a valid email, languageCode and verificationType is sent 
    AND an unknown Error occurs
    THEN the response will be a UnknownAppException
    AND the UnkownErrorException status code will be 500
    AND the errorCode will be "unknown-error"
    AND the codeNumber will be "NA"''', () async {
      when(() => mockDio.post(path!, data: {
            'email': testEmail,
            'languageCode': testLanguageCode,
            'verificationType': testVerificationType.name,
          })).thenThrow(Exception('mock exception'));
      expect(
        () async => makeAuthRepository().sendVerificationCodeByEmail(
          testEmail,
          testLanguageCode,
          testVerificationType,
        ),
        throwsA(
          isA<UnknownErrorException>()
              .having((e) => e.errorCode, 'errorCode', 'unknown-error')
              .having((e) => e.codeNumber, 'codeNumber', 'NA')
              .having((e) => e.statusCode, 'statusCode',
                  HttpStatus.internalServerError),
        ),
      );
      verify(() => mockDio.post(path!, data: {
            'email': testEmail,
            'languageCode': testLanguageCode,
            'verificationType': testVerificationType.name,
          })).called(1);
    });
  });

  group('Auth Repository Create Account With Email And Verification Code', () {
    const expectedResponse = {'customToken': expectedCustomToken, 'code': 0};

    setUp(() {
      reset(mockDio);
    });

    setUpAll(() {
      path = '/createAccountAndCustomTokenWithEmailRequest';
      options = RequestOptions(path: path!);
    });
    test('''WHEN a valid email and verification code are sent
    THEN the response will have a status code 200
    AND a { customToken: 'fake_token', code: 0} response body
    ''', () async {
      when(() => mockDio.post(path!, data: {
            'email': testEmail,
            'code': testVerificationCode,
            'languageCode': testLanguageCode,
          })).thenAnswer((_) async => Response(
            data: expectedResponse,
            statusCode: HttpStatus.ok,
            requestOptions: options!,
          ));
      expect(
        await makeAuthRepository().createAccountWithEmailAndVerificationCode(
          testEmail,
          testVerificationCode,
          testLanguageCode,
        ),
        expectedCustomToken,
      );

      verify(() => mockDio.post(path!, data: {
            'email': testEmail,
            'code': testVerificationCode,
            'languageCode': testLanguageCode,
          })).called(1);
    });

    test('''
    WHEN a valid email and verification code are sent
    AND the customToken is not included in the response
    THEN the response will be a CustomTokenFailedException
    AND the CustomTokenFailedException status code will be 501
    AND the errorCode will be "custom-token-failed"
    And the codeNumber will be 2004
    ''', () async {
      when(() => mockDio.post(path!, data: {
            'email': testEmail,
            'code': testVerificationCode,
            'languageCode': testLanguageCode,
          })).thenAnswer((_) async => Response(
            data: {'code': 0},
            statusCode: HttpStatus.ok,
            requestOptions: options!,
          ));
      expect(
        () async =>
            makeAuthRepository().createAccountWithEmailAndVerificationCode(
          testEmail,
          testVerificationCode,
          testLanguageCode,
        ),
        throwsA(
          isA<CustomTokenFailedException>()
              .having((e) => e.errorCode, 'errorCode', 'custom-token-failed')
              .having((e) => e.codeNumber, 'codeNumber', '2004')
              .having(
                (e) => e.statusCode,
                'statusCode',
                HttpStatus.notImplemented,
              ),
        ),
      );
      verify(() => mockDio.post(path!, data: {
            'email': testEmail,
            'code': testVerificationCode,
            'languageCode': testLanguageCode,
          })).called(1);
    });

    test('''WHEN an invalid email is sent 
    AND the code cannot be verified
    THEN the response will be a CustomAppException
    AND the CustomAppException status code will be 412
    AND the errorCode will be "document-not-found"
    AND the codeNumber will be 0106
    ''', () async {
      when(() => mockDio.post(path!, data: {
            'email': testEmail,
            'code': testVerificationCode,
            'languageCode': testLanguageCode,
          })).thenThrow(DioException(
        requestOptions: options!,
        response: Response(
          requestOptions: options!,
          data: {
            'details': {
              'name': 'DOCUMENT_NOT_FOUND',
              'codeNumber': '0106',
              'prefix': 'store',
              'errorCode': 'document-not-found',
            },
            'message': 'The code could not be retrieved.',
            'status': 'NOT_FOUND',
          },
          statusCode: HttpStatus.preconditionFailed,
        ),
      ));
      expect(
        () async =>
            makeAuthRepository().createAccountWithEmailAndVerificationCode(
          testEmail,
          testVerificationCode,
          testLanguageCode,
        ),
        throwsA(
          isA<CustomAppException>()
              .having((e) => e.errorCode, 'errorCode', 'document-not-found')
              .having((e) => e.codeNumber, 'codeNumber', '0106')
              .having((e) => e.statusCode, 'statusCode',
                  HttpStatus.preconditionFailed),
        ),
      );
      verify(() => mockDio.post(path!, data: {
            'email': testEmail,
            'code': testVerificationCode,
            'languageCode': testLanguageCode,
          })).called(1);
    });

    test('''
    WHEN a valid email is sent 
    AND the code is incorrect
    THEN the response will be an IncorrectVerificationCodeException
    AND the IncorrectVerificationCodeException status code will be 409
    AND the errorCode will be "incorrect-verification-code"
    AND the codeNumber will be 2003
    ''', () async {
      when(() => mockDio.post(path!, data: {
            'email': testEmail,
            'code': testVerificationCode,
            'languageCode': testLanguageCode,
          })).thenThrow(DioException(
        requestOptions: options!,
        response: Response(
          requestOptions: options!,
          data: {
            'details': {
              'name': 'INCORRECT_VERIFICATION_CODE',
              'codeNumber': '2003',
              'prefix': 'piix-auth',
              'errorCode': 'incorrect-verification-code',
            },
            'message': 'The verification code is incorrect.',
            'status': 'ABORTED',
          },
          statusCode: HttpStatus.conflict,
        ),
      ));
      expect(
        () async =>
            makeAuthRepository().createAccountWithEmailAndVerificationCode(
          testEmail,
          testVerificationCode,
          testLanguageCode,
        ),
        throwsA(
          isA<IncorrectVerificationCodeException>()
              .having(
                (e) => e.errorCode,
                'errorCode',
                'incorrect-verification-code',
              )
              .having((e) => e.codeNumber, 'codeNumber', '2003')
              .having((e) => e.statusCode, 'statusCode', HttpStatus.conflict),
        ),
      );
      verify(() => mockDio.post(path!, data: {
            'email': testEmail,
            'code': testVerificationCode,
            'languageCode': testLanguageCode,
          })).called(1);
    });

    test('''
    WHEN a valid email and verification code are sent
    AND the user cannot be created in Firebase
    THEN the response will be a CustomAppException
    AND the CustomAppException status code will be 412
    AND the errorCode will be "user-not-created"
    AND the codeNumber will be 0009
    ''', () async {
      when(() => mockDio.post(path!, data: {
            'email': testEmail,
            'code': testVerificationCode,
            'languageCode': testLanguageCode,
          })).thenThrow(DioException(
        requestOptions: options!,
        response: Response(
          requestOptions: options!,
          data: {
            'details': {
              'name': 'USER_NOT_CREATED',
              'codeNumber': '0009',
              'prefix': 'auth',
              'errorCode': 'user-not-created',
            },
            'message': 'Could not create the user in Firebase.',
            'status': 'ABORTED',
          },
          statusCode: HttpStatus.preconditionFailed,
        ),
      ));
      expect(
        () async =>
            makeAuthRepository().createAccountWithEmailAndVerificationCode(
          testEmail,
          testVerificationCode,
          testLanguageCode,
        ),
        throwsA(
          isA<CustomAppException>()
              .having((e) => e.errorCode, 'errorCode', 'user-not-created')
              .having((e) => e.codeNumber, 'codeNumber', '0009')
              .having((e) => e.statusCode, 'statusCode',
                  HttpStatus.preconditionFailed),
        ),
      );
      verify(() => mockDio.post(path!, data: {
            'email': testEmail,
            'code': testVerificationCode,
            'languageCode': testLanguageCode,
          })).called(1);
    });

    test('''
    WHEN a valid email and verification code are sent
    AND the user cannot be stored in the database
    THEN the response will be a CustomAppException
    AND the CustomAppException status code will be 412
    AND the errorCode will be "document-not-added"
    AND the codeNumber will be 0101
    ''', () async {
      when(() => mockDio.post(path!, data: {
            'email': testEmail,
            'code': testVerificationCode,
            'languageCode': testLanguageCode,
          })).thenThrow(DioException(
        requestOptions: options!,
        response: Response(
          requestOptions: options!,
          data: {
            'details': {
              'name': 'DOCUMENT_NOT_ADDED',
              'codeNumber': '0101',
              'prefix': 'store',
              'errorCode': 'document-not-added',
            },
            'message': 'Could not store the user in the database.',
            'status': 'ABORTED',
          },
          statusCode: HttpStatus.preconditionFailed,
        ),
      ));
      expect(
        () async =>
            makeAuthRepository().createAccountWithEmailAndVerificationCode(
          testEmail,
          testVerificationCode,
          testLanguageCode,
        ),
        throwsA(
          isA<CustomAppException>()
              .having((e) => e.errorCode, 'errorCode', 'document-not-added')
              .having((e) => e.codeNumber, 'codeNumber', '0101')
              .having((e) => e.statusCode, 'statusCode',
                  HttpStatus.preconditionFailed),
        ),
      );
      verify(() => mockDio.post(path!, data: {
            'email': testEmail,
            'code': testVerificationCode,
            'languageCode': testLanguageCode,
          })).called(1);
    });

    test('''
    WHEN a valid email and verification code are sent
    AND the custom token cannot be retrieved
    THEN the response will be a CustomTokenFailedException
    AND the CustomTokenFailedException status code will be 500
    AND the errorCode will be "custom-token-failed"
    AND the codeNumber will be 2004
    ''', () async {
      when(() => mockDio.post(path!, data: {
            'email': testEmail,
            'code': testVerificationCode,
            'languageCode': testLanguageCode,
          })).thenThrow(DioException(
        requestOptions: options!,
        response: Response(
          requestOptions: options!,
          data: {
            'details': {
              'name': 'CUSTOM_TOKEN_FAILED',
              'codeNumber': '2004',
              'prefix': 'piix-auth',
              'errorCode': 'custom-token-failed',
            },
            'message': 'Could not retrieve the custom token.',
            'status': 'NOT_IMPLEMENTED',
          },
          statusCode: HttpStatus.internalServerError,
        ),
      ));
      expect(
        () async =>
            makeAuthRepository().createAccountWithEmailAndVerificationCode(
          testEmail,
          testVerificationCode,
          testLanguageCode,
        ),
        throwsA(
          isA<CustomTokenFailedException>()
              .having((e) => e.errorCode, 'errorCode', 'custom-token-failed')
              .having((e) => e.codeNumber, 'codeNumber', '2004')
              .having(
                  (e) => e.statusCode, 'statusCode', HttpStatus.notImplemented),
        ),
      );
      verify(() => mockDio.post(path!, data: {
            'email': testEmail,
            'code': testVerificationCode,
            'languageCode': testLanguageCode,
          })).called(1);
    });

    test('''
    WHEN a valid email and verification code are sent
    AND an unknown DioException occurs
    THEN the response will be a CustomAppException
    AND the UnknownAppException status code will be 500
    AND the errorCode will be "dio-exception"
    AND the codeNumber will be "NA"
    ''', () async {
      when(() => mockDio.post(path!, data: {
            'email': testEmail,
            'code': testVerificationCode,
            'languageCode': testLanguageCode,
          })).thenThrow(DioException(
        requestOptions: options!,
      ));
      expect(
        () async =>
            makeAuthRepository().createAccountWithEmailAndVerificationCode(
          testEmail,
          testVerificationCode,
          testLanguageCode,
        ),
        throwsA(
          isA<CustomAppException>()
              .having((e) => e.errorCode, 'errorCode', 'dio-exception')
              .having((e) => e.codeNumber, 'codeNumber', 'NA')
              .having((e) => e.statusCode, 'statusCode',
                  HttpStatus.internalServerError),
        ),
      );
      verify(() => mockDio.post(path!, data: {
            'email': testEmail,
            'code': testVerificationCode,
            'languageCode': testLanguageCode,
          })).called(1);
    });

    test('''
    WHEN a valid email and verification code are sent
    AND an unknown Error occurs
    THEN the response will be a UnknownAppException
    AND the UnkownErrorException status code will be 500
    AND the errorCode will be "unknown-error"
    AND the codeNumber will be "NA"''', () async {
      when(() => mockDio.post(path!, data: {
            'email': testEmail,
            'code': testVerificationCode,
          })).thenThrow(Exception('mock exception'));
      expect(
        () async => makeAuthRepository()
            .createAccountWithEmailAndVerificationCode(
                testEmail, testVerificationCode, testLanguageCode),
        throwsA(
          isA<UnknownErrorException>()
              .having((e) => e.errorCode, 'errorCode', 'unknown-error')
              .having((e) => e.codeNumber, 'codeNumber', 'NA')
              .having((e) => e.statusCode, 'statusCode',
                  HttpStatus.internalServerError),
        ),
      );
      verify(() => mockDio.post(path!, data: {
            'email': testEmail,
            'code': testVerificationCode,
            'languageCode': testLanguageCode,
          })).called(1);
    });
  });

  group('Auth Repository Get Custom Token With Email And Verification Code',
      () {
    const expectedResponse = {'customToken': expectedCustomToken, 'code': 0};
    setUp(() {
      reset(mockDio);
    });

    setUpAll(() {
      path = '/getCustomTokenForCustomSignInRequest';
      options = RequestOptions(path: path!);
    });
    test('''
    WHEN a valid email and verification code are sent
    THEN the response will have a status code 200
    AND a { customToken: 'fake_token', code: 0 } response body
    ''', () async {
      when(() => mockDio.post(path!, data: {
            'email': testEmail,
            'code': testVerificationCode,
            'languageCode': testLanguageCode,
          })).thenAnswer((_) async => Response(
            data: expectedResponse,
            statusCode: HttpStatus.ok,
            requestOptions: options!,
          ));
      expect(
          await makeAuthRepository().getCustomTokenWithEmailAndVerificationCode(
              testEmail, testVerificationCode, testLanguageCode),
          expectedCustomToken);

      verify(() => mockDio.post(path!, data: {
            'email': testEmail,
            'code': testVerificationCode,
            'languageCode': testLanguageCode,
          })).called(1);
    });

    test('''
    WHEN a valid email and verification code are sent
    AND the customToken is not included in the response
    THEN the response will be a CustomTokenFailedException
    AND the CustomTokenFailedException status code will be 501
    AND the errorCode will be "custom-token-failed"
    And the codeNumber will be 2004
    ''', () async {
      when(() => mockDio.post(path!, data: {
            'email': testEmail,
            'code': testVerificationCode,
            'languageCode': testLanguageCode,
          })).thenAnswer((_) async => Response(
            data: {'code': 0},
            statusCode: HttpStatus.ok,
            requestOptions: options!,
          ));
      expect(
        () async =>
            makeAuthRepository().getCustomTokenWithEmailAndVerificationCode(
          testEmail,
          testVerificationCode,
          testLanguageCode,
        ),
        throwsA(
          isA<CustomTokenFailedException>()
              .having((e) => e.errorCode, 'errorCode', 'custom-token-failed')
              .having((e) => e.codeNumber, 'codeNumber', '2004')
              .having(
                (e) => e.statusCode,
                'statusCode',
                HttpStatus.notImplemented,
              ),
        ),
      );
      verify(() => mockDio.post(path!, data: {
            'email': testEmail,
            'code': testVerificationCode,
            'languageCode': testLanguageCode,
          })).called(1);
    });

    test('''WHEN an invalid email is sent 
    AND the code cannot be verified
    THEN the response will be a CustomAppException
    AND the CustomAppException status code will be 412
    AND the errorCode will be "document-not-found"
    AND the codeNumber will be 0106
    ''', () async {
      when(() => mockDio.post(path!, data: {
            'email': testEmail,
            'code': testVerificationCode,
            'languageCode': testLanguageCode,
          })).thenThrow(DioException(
        requestOptions: options!,
        response: Response(
          requestOptions: options!,
          data: {
            'details': {
              'name': 'DOCUMENT_NOT_FOUND',
              'codeNumber': '0106',
              'prefix': 'store',
              'errorCode': 'document-not-found',
            },
            'message': 'The code could not be retrieved.',
            'status': 'NOT_FOUND',
          },
          statusCode: HttpStatus.preconditionFailed,
        ),
      ));
      expect(
        () async => makeAuthRepository()
            .getCustomTokenWithEmailAndVerificationCode(
                testEmail, testVerificationCode, testLanguageCode),
        throwsA(
          isA<CustomAppException>()
              .having((e) => e.errorCode, 'errorCode', 'document-not-found')
              .having((e) => e.codeNumber, 'codeNumber', '0106')
              .having((e) => e.statusCode, 'statusCode',
                  HttpStatus.preconditionFailed),
        ),
      );
      verify(() => mockDio.post(path!, data: {
            'email': testEmail,
            'code': testVerificationCode,
            'languageCode': testLanguageCode,
          })).called(1);
    });

    test('''
    WHEN a valid email is sent 
    AND the code is incorrect
    THEN the response will be an IncorrectVerificationCodeException
    AND the IncorrectVerificationCodeException status code will be 409
    AND the errorCode will be "incorrect-verification-code"
    AND the codeNumber will be 2003
    ''', () async {
      when(() => mockDio.post(path!, data: {
            'email': testEmail,
            'code': testVerificationCode,
            'languageCode': testLanguageCode,
          })).thenThrow(DioException(
        requestOptions: options!,
        response: Response(
          requestOptions: options!,
          data: {
            'details': {
              'name': 'INCORRECT_VERIFICATION_CODE',
              'codeNumber': '2003',
              'prefix': 'piix-auth',
              'errorCode': 'incorrect-verification-code',
            },
            'message': 'The verification code is incorrect.',
            'status': 'ABORTED',
          },
          statusCode: HttpStatus.conflict,
        ),
      ));
      expect(
        () async =>
            makeAuthRepository().getCustomTokenWithEmailAndVerificationCode(
          testEmail,
          testVerificationCode,
          testLanguageCode,
        ),
        throwsA(
          isA<IncorrectVerificationCodeException>()
              .having(
                (e) => e.errorCode,
                'errorCode',
                'incorrect-verification-code',
              )
              .having((e) => e.codeNumber, 'codeNumber', '2003')
              .having((e) => e.statusCode, 'statusCode', HttpStatus.conflict),
        ),
      );
      verify(() => mockDio.post(path!, data: {
            'email': testEmail,
            'code': testVerificationCode,
            'languageCode': testLanguageCode,
          })).called(1);
    });

    test('''
    WHEN a valid email and verification code are sent
    AND the user cannot be retrieved from Firestore with the email
    THEN the response will be a CustomAppException
    AND the CustomAppException status code will be 412
    AND the errorCode will be "query-is-empty"
    AND the codeNumber will be 0107
    ''', () async {
      when(() => mockDio.post(path!, data: {
            'email': testEmail,
            'code': testVerificationCode,
            'languageCode': testLanguageCode,
          })).thenThrow(DioException(
        requestOptions: options!,
        response: Response(
          requestOptions: options!,
          data: {
            'details': {
              'name': 'QUERY_IS_EMPTY',
              'codeNumber': '0107',
              'prefix': 'store',
              'errorCode': 'query-is-empty',
            },
            'message': 'The query is empty.',
            'status': 'FAILED_PRECONDITION',
          },
          statusCode: HttpStatus.preconditionFailed,
        ),
      ));
      expect(
        () async =>
            makeAuthRepository().getCustomTokenWithEmailAndVerificationCode(
          testEmail,
          testVerificationCode,
          testLanguageCode,
        ),
        throwsA(
          isA<CustomAppException>()
              .having((e) => e.errorCode, 'errorCode', 'query-is-empty')
              .having((e) => e.codeNumber, 'codeNumber', '0107')
              .having((e) => e.statusCode, 'statusCode',
                  HttpStatus.preconditionFailed),
        ),
      );
      verify(() => mockDio.post(path!, data: {
            'email': testEmail,
            'code': testVerificationCode,
            'languageCode': testLanguageCode,
          })).called(1);
    });
    test('''
    WHEN a valid email and verification code are sent
    AND the user cannot be found with the email
    THEN the response will be a CustomAppException
    AND the CustomAppException status code will be 500
    AND the errorCode will be "document-not-found"
    AND the codeNumber will be 0106
    ''', () async {
      when(() => mockDio.post(path!, data: {
            'email': testEmail,
            'code': testVerificationCode,
            'languageCode': testLanguageCode,
          })).thenThrow(DioException(
        requestOptions: options!,
        response: Response(
          requestOptions: options!,
          data: {
            'details': {
              'name': 'DOCUMENT_NOT_FOUND',
              'codeNumber': '0106',
              'prefix': 'store',
              'errorCode': 'document-not-found',
            },
            'message': 'The user could not be found.',
            'status': 'NOT_FOUND',
          },
          statusCode: HttpStatus.notFound,
        ),
      ));
      expect(
        () async =>
            makeAuthRepository().getCustomTokenWithEmailAndVerificationCode(
          testEmail,
          testVerificationCode,
          testLanguageCode,
        ),
        throwsA(
          isA<CustomAppException>()
              .having((e) => e.errorCode, 'errorCode', 'document-not-found')
              .having((e) => e.codeNumber, 'codeNumber', '0106')
              .having((e) => e.statusCode, 'statusCode', HttpStatus.notFound),
        ),
      );
      verify(() => mockDio.post(path!, data: {
            'email': testEmail,
            'code': testVerificationCode,
            'languageCode': testLanguageCode,
          })).called(1);
    });
    test('''
    WHEN a valid email and verification code are sent
    AND the custom token cannot be retrieved
    THEN the response will be a CustomTokenFailedException
    AND the CustomTokenFailedException status code will be 500
    AND the errorCode will be "custom-token-failed"
    AND the codeNumber will be 2004
    ''', () async {
      when(() => mockDio.post(path!, data: {
            'email': testEmail,
            'code': testVerificationCode,
            'languageCode': testLanguageCode,
          })).thenThrow(DioException(
        requestOptions: options!,
        response: Response(
          requestOptions: options!,
          data: {
            'details': {
              'name': 'CUSTOM_TOKEN_FAILED',
              'codeNumber': '2004',
              'prefix': 'piix-auth',
              'errorCode': 'custom-token-failed',
            },
            'message': 'Could not retrieve the custom token.',
            'status': 'NOT_IMPLEMENTED',
          },
          statusCode: HttpStatus.internalServerError,
        ),
      ));
      expect(
        () async =>
            makeAuthRepository().getCustomTokenWithEmailAndVerificationCode(
          testEmail,
          testVerificationCode,
          testLanguageCode,
        ),
        throwsA(
          isA<CustomTokenFailedException>()
              .having((e) => e.errorCode, 'errorCode', 'custom-token-failed')
              .having((e) => e.codeNumber, 'codeNumber', '2004')
              .having(
                  (e) => e.statusCode, 'statusCode', HttpStatus.notImplemented),
        ),
      );
      verify(() => mockDio.post(path!, data: {
            'email': testEmail,
            'code': testVerificationCode,
            'languageCode': testLanguageCode,
          })).called(1);
    });

    test('''
    WHEN a valid email and verification code are sent
    AND an unknown DioException occurs
    THEN the response will be a CustomAppException
    AND the UnknownAppException status code will be 500
    AND the errorCode will be "dio-exception"
    AND the codeNumber will be "NA"
    ''', () async {
      when(() => mockDio.post(path!, data: {
            'email': testEmail,
            'code': testVerificationCode,
            'languageCode': testLanguageCode,
          })).thenThrow(DioException(
        requestOptions: options!,
      ));
      expect(
        () async =>
            makeAuthRepository().getCustomTokenWithEmailAndVerificationCode(
          testEmail,
          testVerificationCode,
          testLanguageCode,
        ),
        throwsA(
          isA<CustomAppException>()
              .having((e) => e.errorCode, 'errorCode', 'dio-exception')
              .having((e) => e.codeNumber, 'codeNumber', 'NA')
              .having((e) => e.statusCode, 'statusCode',
                  HttpStatus.internalServerError),
        ),
      );
      verify(() => mockDio.post(path!, data: {
            'email': testEmail,
            'code': testVerificationCode,
            'languageCode': testLanguageCode,
          })).called(1);
    });

    test('''
    WHEN a valid email and verification code are sent
    AND an unknown Error occurs
    THEN the response will be a UnknownAppException
    AND the UnkownErrorException status code will be 500
    AND the errorCode will be "unknown-error"
    AND the codeNumber will be "NA"''', () async {
      when(() => mockDio.post(path!, data: {
            'email': testEmail,
            'code': testVerificationCode,
          })).thenThrow(Exception('mock exception'));
      expect(
        () async =>
            makeAuthRepository().getCustomTokenWithEmailAndVerificationCode(
          testEmail,
          testVerificationCode,
          testLanguageCode,
        ),
        throwsA(
          isA<UnknownErrorException>()
              .having((e) => e.errorCode, 'errorCode', 'unknown-error')
              .having((e) => e.codeNumber, 'codeNumber', 'NA')
              .having((e) => e.statusCode, 'statusCode',
                  HttpStatus.internalServerError),
        ),
      );
      verify(() => mockDio.post(path!, data: {
            'email': testEmail,
            'code': testVerificationCode,
            'languageCode': testLanguageCode,
          })).called(1);
    });
  });

  group('Auth Repository Revoke Refresh Tokens', () {
    const expectedResponse = {'code': 0};

    setUp(() {
      reset(mockDio);
    });

    setUpAll(() {
      path = '/revokeRefreshTokensRequest';
      options = RequestOptions(path: path!);
    });

    test('''
    WHEN an idToken is sent in the authorization headers
    THEN the response will have a status code 200
    AND the response body will be { code: 0 }
    ''', () async {
      when(() => mockDio.put(path!)).thenAnswer((_) async => Response(
            data: expectedResponse,
            statusCode: HttpStatus.ok,
            requestOptions: options!,
          ));
      expect(await makeAuthRepository().revokeRefreshTokens(),
          isA<Response>().having((r) => r.data, 'data', expectedResponse));
      verify(() => mockDio.put(path!)).called(1);
    });
    test(''''
    WHEN an idToken is not sent in the authorization headers
    THEN the response will be a CustomAppException
    AND the CustomAppException status code will be 401
    AND the errorCode will be "no-id-token-present"
    AND the codeNumber will be 2005
    ''', () async {
      when(() => mockDio.put(path!)).thenThrow(DioException(
        requestOptions: options!,
        response: Response(
          requestOptions: options!,
          data: {
            'details': {
              'name': 'NO_ID_TOKEN_PRESENT',
              'codeNumber': '2005',
              'prefix': 'piix-auth',
              'errorCode': 'no-id-token-present',
            },
            'message': 'No id token was present in the request.',
            'status': 'PERMISSION_DENIED',
          },
          statusCode: HttpStatus.unauthorized,
        ),
      ));
      expect(
        () async => makeAuthRepository().revokeRefreshTokens(),
        throwsA(
          isA<CustomAppException>()
              .having((e) => e.errorCode, 'errorCode', 'no-id-token-present')
              .having((e) => e.codeNumber, 'codeNumber', '2005')
              .having(
                (e) => e.statusCode,
                'statusCode',
                HttpStatus.unauthorized,
              ),
        ),
      );
      verify(() => mockDio.put(path!)).called(1);
    });
    test('''
    WHEN an idToken is sent in the authorization headers
    AND the idToken verified is revoked or expired
    THEN the response will be a CustomAppException
    AND the CustomAppException status code will be 406
    AND the errorCode will be "id-token-expired"
    AND the codeNumber will be 0001
    ''', () async {
      when(() => mockDio.put(path!)).thenThrow(DioException(
        requestOptions: options!,
        response: Response(
          requestOptions: options!,
          data: {
            'details': {
              'name': 'ID_TOKEN_EXPIRED',
              'codeNumber': '0001',
              'prefix': 'auth',
              'errorCode': 'id-token-expired',
            },
            'message': 'The id token has expired.',
            'status': 'FAILED_PRECONDITION',
          },
          statusCode: HttpStatus.notAcceptable,
        ),
      ));
      expect(
        () async => makeAuthRepository().revokeRefreshTokens(),
        throwsA(
          isA<CustomAppException>()
              .having((e) => e.errorCode, 'errorCode', 'id-token-expired')
              .having((e) => e.codeNumber, 'codeNumber', '0001')
              .having(
                (e) => e.statusCode,
                'statusCode',
                HttpStatus.notAcceptable,
              ),
        ),
      );
      verify(() => mockDio.put(path!)).called(1);
    });
    test('''
    WHEN an idToken is sent in the authorization headers
    AND the idToken verified is invalid
    THEN the response will be a CustomAppException
    AND the CustomAppException status code will be 401
    AND the errorCode will be "invalid-id-token"
    AND the codeNumber will be 0004
    ''', () async {
      when(() => mockDio.put(path!)).thenThrow(DioException(
        requestOptions: options!,
        response: Response(
          requestOptions: options!,
          data: {
            'details': {
              'name': 'INVALID_ID_TOKEN',
              'codeNumber': '0004',
              'prefix': 'auth',
              'errorCode': 'invalid-id-token',
            },
            'message': 'The id token is invalid.',
            'status': 'PERMISSION_DENIED',
          },
          statusCode: HttpStatus.unauthorized,
        ),
      ));
      expect(
        () async => makeAuthRepository().revokeRefreshTokens(),
        throwsA(
          isA<CustomAppException>()
              .having((e) => e.errorCode, 'errorCode', 'invalid-id-token')
              .having((e) => e.codeNumber, 'codeNumber', '0004')
              .having(
                (e) => e.statusCode,
                'statusCode',
                HttpStatus.unauthorized,
              ),
        ),
      );
      verify(() => mockDio.put(path!)).called(1);
    });

    test('''
    WHEN an idToken is sent in the authorization headers
    AND an unknown DioException occurs
    THEN the response will be a CustomAppException
    AND the CustomAppException status code will be 500
    AND the errorCode will be "dio-exception"
    AND the codeNumber will be "NA"
    ''', () async {
      when(() => mockDio.put(path!)).thenThrow(DioException(
        requestOptions: options!,
      ));
      expect(
        () async => makeAuthRepository().revokeRefreshTokens(),
        throwsA(
          isA<CustomAppException>()
              .having((e) => e.errorCode, 'errorCode', 'dio-exception')
              .having((e) => e.codeNumber, 'codeNumber', 'NA')
              .having((e) => e.statusCode, 'statusCode',
                  HttpStatus.internalServerError),
        ),
      );
      verify(() => mockDio.put(path!)).called(1);
    });
    test('''
    WHEN an idToken is sent in the authorization headers
    AND an unknown Error occurs
    THEN the response will be a UnknownAppException
    AND the UnkownErrorException status code will be 500
    AND the errorCode will be "unknown-error"
    AND the codeNumber will be "NA"
    ''', () async {
      when(() => mockDio.put(path!)).thenThrow(Exception('mock exception'));
      expect(
        () async => makeAuthRepository().revokeRefreshTokens(),
        throwsA(
          isA<UnknownErrorException>()
              .having((e) => e.errorCode, 'errorCode', 'unknown-error')
              .having((e) => e.codeNumber, 'codeNumber', 'NA')
              .having((e) => e.statusCode, 'statusCode',
                  HttpStatus.internalServerError),
        ),
      );
      verify(() => mockDio.put(path!)).called(1);
    });
  });
}
