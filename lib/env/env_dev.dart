import 'package:envied/envied.dart';
import 'package:piix_mobile/env/env_interface.dart';

part 'env_dev.g.dart';

/// Development environment variables
@Envied(path: '.env.dev')
class DevEnv implements Env {
  //** Firebase environment variables */
  @EnviedField(varName: 'API_KEY', obfuscate: true)
  @override
  final String apiKey = _DevEnv.apiKey;
  @EnviedField(varName: 'APP_ID', obfuscate: true)
  @override
  final String appId = _DevEnv.appId;
  @EnviedField(varName: 'MESSAGE_SENDER_ID')
  @override
  final String messageSenderId = _DevEnv.messageSenderId;
  @EnviedField(varName: 'PROJECT_ID', obfuscate: true)
  @override
  final String projectId = _DevEnv.projectId;
  @EnviedField(varName: 'PROJECT_ID', obfuscate: true)
  @override
  final String storageBucket = _DevEnv.storageBucket;
  @EnviedField(varName: 'BASE_URL', obfuscate: true)
  @override
  final String baseUrl = _DevEnv.baseUrl;
}
