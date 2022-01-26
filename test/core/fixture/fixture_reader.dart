import 'dart:convert';
import 'dart:io';

class FixtureReader {
  FixtureReader._();

  static String getJsonData(String path) =>
      File('test/$path').readAsStringSync();

  static T getData<T>(String path) =>
      jsonDecode(File('test/$path').readAsStringSync()) as T;
}
