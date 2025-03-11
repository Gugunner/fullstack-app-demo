import 'package:envied/envied.dart';
import 'package:piix_mobile/env/env_interface.dart';

part 'env_prod.g.dart';

/// Prod environment variables
@Envied(path: '.env.prod')
class ProdEnv implements Env {
  //** Firebase environment variables */
  @EnviedField(varName: 'API_KEY', obfuscate: true)
  @override
  final String apiKey = _ProdEnv.apiKey;
  @EnviedField(varName: 'APP_ID', obfuscate: true)
  @override
  final String appId = _ProdEnv.appId;
  @EnviedField(varName: 'MESSAGE_SENDER_ID', obfuscate: true)
  @override
  final String messageSenderId = _ProdEnv.messageSenderId;
  @EnviedField(varName: 'PROJECT_ID', obfuscate: true)
  @override
  final String projectId = _ProdEnv.projectId;
  @EnviedField(varName: 'PROJECT_ID')
  @override
  final String storageBucket = _ProdEnv.storageBucket;
  @EnviedField(varName: 'BASE_URL', obfuscate: true)
  @override
  final String baseUrl = _ProdEnv.baseUrl;
}
