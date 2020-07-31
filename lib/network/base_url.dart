abstract class BaseUrl {
  String dev() => null;

  String getUrl() {
    return dev();
  }
}

Environment currentEnvironment = Environment.DEV;
enum Environment {
  DEV,
}