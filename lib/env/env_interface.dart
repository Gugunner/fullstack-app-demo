///Declared interface should be implemented by a real CustomEnv class
///with actual values.
interface class Env {
  ///The actual api key used to access Firebase project
  final String apiKey = '';

  ///The actual app id of the Firebase project
  final String appId = '';

  ///A special id used for communicating with the Firebase project
  final String messageSenderId = '';

  ///The id of the Firebase project
  final String projectId = '';

  ///The storage bucket of the Firebase project
  final String storageBucket = '';

  //The url of the backend server
  final String baseUrl = '';
}
