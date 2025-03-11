import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:piix_mobile/app_bootstrap.dart';
import 'package:piix_mobile/env/env_local.dart';
import 'package:piix_mobile/src/network/app_exception.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_dio.g.dart';

///The Dio wrapper class for the application
class AppDio {
  ///Constructor for the AppDio class
  const AppDio(this._dio);

  final Dio _dio;

  ///Getter for the Dio instance
  Dio get dio => _dio;

  ///Configures the Dio instance with the base url
  void configureDio(String baseUrl) {
    _dio
      ..options.baseUrl = baseUrl
      ..options.connectTimeout = const Duration(seconds: 30)
      ..options.receiveTimeout = const Duration(seconds: 30)
      ..options.headers = {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer fake_token'
      }
      //Add the interceptor to the Dio instance
      ..interceptors.add(
        _AppDioInterceptor(FirebaseAuth.instance),
      );
    return;
  }

  ///Performs a POST request that wraps the Dio post method
  ///to handle exceptions and errors
  ///as CustomAppException and UnkownErrorException
  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      //Perform the post request
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (dioException) {
      //Catch the DioException and throw a CustomAppException
      throw CustomAppException.fromModulesException(dioException);
    } catch (error) {
      //Catch any other error and throw an UnkownErrorException
      //TODO: Log the error to a logging service
      throw UnknownErrorException(error);
    }
  }

  ///Performs a PUT request that wraps the Dio put method
  ///to handle exceptions and errors
  ///as CustomAppException and UnkownErrorException
  Future<Response<T>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      //Perform the put request
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (dioException) {
      //Catch the DioException and throw a CustomAppException
      throw CustomAppException.fromModulesException(dioException);
    } catch (error) {
      //Catch any other error and throw an UnkownErrorException
      //TODO: Log the error to a logging service
      throw UnknownErrorException(error);
    }
  }

  ///Performs a GET request that wraps the Dio get method
  ///to handle exceptions and errors
  ///as CustomAppException and UnkownErrorException
  Future<Response<T>> get<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      //Perform the get request
      return await _dio.get<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (dioException) {
      //Catch the DioException and throw a CustomAppException
      throw CustomAppException.fromModulesException(dioException);
    } catch (error) {
      //Catch any other error and throw an UnkownErrorException
      //TODO: Log the error to a logging service
      throw UnknownErrorException(error);
    }
  }

  ///Performs a DELETE request that wraps the Dio delete method
  ///to handle exceptions and errors
  ///as CustomAppException and UnkownErrorException
  Future<Response<T>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      //Perform the delete request
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } on DioException catch (dioException) {
      //Catch the DioException and throw a CustomAppException
      throw CustomAppException.fromModulesException(dioException);
    } catch (error) {
      //Catch any other error and throw an UnkownErrorException
      //TODO: Log the error to a logging service
      throw UnknownErrorException(error);
    }
  }

  ///Performs a request that wraps the Dio request method
  Future<Response<T>> request<T>(
    String url, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Options? options,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      //Perform the request
      return await _dio.request<T>(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (dioException) {
      //Catch the DioException and throw a CustomAppException
      throw CustomAppException.fromModulesException(dioException);
    } catch (error) {
      //Catch any other error and throw an UnkownErrorException
      //TODO: Log the error to a logging service
      throw UnknownErrorException(error);
    }
  }
}

///The Dio interceptor class for the application
///that adds the authorization header to the request
///using the Firebase Auth idToken.
///
///It also handles the idToken expiration by retrying the request
///with a new idToken.
class _AppDioInterceptor extends Interceptor {
  const _AppDioInterceptor(this._firebaseAuth);

  final FirebaseAuth _firebaseAuth;

  Future<void> _validateNoCurrentFirebaseUser(String email) async {
    final currentUser = _firebaseAuth.currentUser;
    if (currentUser == null || currentUser.email == email) return;
    if (kDebugMode) {
      print('User mismatch detected: Signed in user (${currentUser.email}) '
          'vs. login attempt ($email). Signing out...');
    }
    //User stored in firebase is different
    await _firebaseAuth.signOut();
  }

  ///Adds the authorization header to the request
  ///using the Firebase Auth idToken.
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.path.contains('sendVerificationCodeRequest') &&
        options.method == 'POST') {
      final Map<String, dynamic>? requestBody = options.data;
      final email = requestBody?['email'];
      if (email != null) {
        await _validateNoCurrentFirebaseUser(email);
      }
    }
    //Get the idToken from the Firebase Auth instance
    final idToken = await _firebaseAuth.currentUser?.getIdToken();
    //Add the authorization header to the request
    if (idToken != null) {
      options.headers['authorization'] = 'Bearer $idToken';
    }
    //Call the next handler
    super.onRequest(options, handler);
  }

  ///Handles the DioException with status code 406 and
  ///errorCode 'id-token-expired'
  @override
  void onError(DioException dioException, ErrorInterceptorHandler handler) {
    //Check if the DioException has status code 406 and
    //errorCode 'id-token-expired'
    if (dioException.response?.statusCode == HttpStatus.notAcceptable &&
        dioException.response?.data['details']?['errorCode'] ==
            'id-token-expired') {
      //Get the new idToken from the Firebase Auth instance
      //and retry the request
      _firebaseAuth.currentUser!
          .getIdToken(true)
          .then((idToken) => _retryRequest(idToken!, dioException, handler));
    } else {
      super.onError(dioException, handler);
    }
  }

  ///Retries the request with the new idToken
  Future<void> _retryRequest(String idToken, DioException dioException,
      ErrorInterceptorHandler handler) async {
    //Get the request options from the DioException
    final requestOptions = dioException.requestOptions;
    //Add the new idToken to the authorization header
    requestOptions.headers['authorization'] = 'Bearer $idToken';
    //Create a new AppDio instance and configure it with the base url
    final appDio = AppDio(Dio());
    //Perform the request with the new idToken
    appDio.configureDio(requestOptions.baseUrl);
    try {
      //Perform the request
      final response = await appDio.request(
        dioException.requestOptions.path,
        data: dioException.requestOptions.data,
        queryParameters: dioException.requestOptions.queryParameters,
        cancelToken: dioException.requestOptions.cancelToken,
        options: Options(
          method: requestOptions.method,
          headers: requestOptions.headers,
        ),
        onSendProgress: requestOptions.onSendProgress,
        onReceiveProgress: requestOptions.onReceiveProgress,
      );
      //Resolve the handler with the response
      handler.resolve(response);
    } catch (dioException) {
      //Reject the handler with the DioException
      handler.reject(dioException as DioException);
    }
  }
}

@Riverpod(keepAlive: true)
AppDio appDio(AppDioRef ref) {
  final appDio = AppDio(Dio());
  String baseUrl;
  final platform = ref.watch(platformProvider);
  final env = ref.watch(envProvider);
  if (platform == TargetPlatform.android && env is LocalEnv) {
    baseUrl = env.adbLocalUrl;
  } else {
    baseUrl = env?.baseUrl ?? '';
  }
  appDio.configureDio(baseUrl);
  return appDio;
}
