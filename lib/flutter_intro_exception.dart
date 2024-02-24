part of 'flutter_intro.dart';

class FlutterIntroException implements Exception {
  final dynamic message;

  FlutterIntroException([this.message]);

  @override
  String toString() {
    Object? message = this.message;
    if (message == null) return "FlutterIntroException";
    return "FlutterIntroException: $message";
  }
}
