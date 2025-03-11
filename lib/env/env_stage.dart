import 'package:envied/envied.dart';
import 'package:piix_mobile/env/env_interface.dart';

part 'env_stage.g.dart';

/// Staging environment variables
@Envied(path: '.env.stage')
class StageEnv implements Env {
  //** Firebase environment variables */
  @EnviedField(varName: 'API_KEY', obfuscate: true)
  @override
  final String apiKey = _StageEnv.apiKey;
  @EnviedField(varName: 'APP_ID', obfuscate: true)
  @override
  final String appId = _StageEnv.appId;
  @EnviedField(varName: 'MESSAGE_SENDER_ID', obfuscate: true)
  @override
  final String messageSenderId = _StageEnv.messageSenderId;
  @EnviedField(varName: 'PROJECT_ID', obfuscate: true)
  @override
  final String projectId = _StageEnv.projectId;
  @EnviedField(varName: 'PROJECT_ID')
  @override
  final String storageBucket = _StageEnv.storageBucket;
  @EnviedField(varName: 'BASE_URL', obfuscate: true)
  @override
  final String baseUrl = _StageEnv.baseUrl;
}
