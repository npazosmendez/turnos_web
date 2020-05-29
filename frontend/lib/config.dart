import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class Config {
  static final String configPath = 'assets/config.json';
  static Config _singleton;
  Map<String, dynamic> _config;

  Config._new();

  static Future<Config> instance() async {
    // NOTE: no me estarían importanod mucho las race conditions acá
    if(_singleton == null) {
      _singleton = Config._new();
      _singleton._config =  json.decode(await rootBundle.loadString(configPath));
    }
    return _singleton;
  }

  dynamic get(String key) => _config[key];
}