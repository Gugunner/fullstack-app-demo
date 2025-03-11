///The possible types requires verification to access
///the app.
enum VerificationType {
  register,
  login;

  bool get isLogin => this == VerificationType.login;
}
