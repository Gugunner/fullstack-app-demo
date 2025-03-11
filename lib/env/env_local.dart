import 'package:envied/envied.dart';
import 'package:piix_mobile/env/env_interface.dart';

part 'env_local.g.dart';

/// Development environment variables
@Envied(path: '.env.local')
class LocalEnv implements Env {
  //** Firebase environment variables */
  @EnviedField(varName: 'API_KEY')
  @override
  final String apiKey = _LocalEnv.apiKey;
  @EnviedField(varName: 'APP_ID')
  @override
  final String appId = _LocalEnv.appId;
  @EnviedField(varName: 'MESSAGE_SENDER_ID')
  @override
  final String messageSenderId = _LocalEnv.messageSenderId;
  @EnviedField(varName: 'PROJECT_ID')
  @override
  final String projectId = _LocalEnv.projectId;
  @EnviedField(varName: 'PROJECT_ID')
  @override
  final String storageBucket = _LocalEnv.storageBucket;
  @EnviedField(varName: 'BASE_URL')
  @override
  final String baseUrl = _LocalEnv.baseUrl;
  @EnviedField(varName: 'ANDROID_LOCAL_URL')
  final String adbLocalUrl = _LocalEnv.adbLocalUrl;
}
