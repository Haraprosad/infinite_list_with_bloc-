import 'package:flutter/material.dart';
import 'package:flutter_infinite_list/flavors/build_config.dart';
import 'package:flutter_infinite_list/flavors/env_config.dart';
import 'package:flutter_infinite_list/flavors/environment.dart';
import 'package:flutter_infinite_list/main.dart';

void main() async{
  EnvConfig devConfig = EnvConfig(
    appName: "Infinite List with bloc",
    baseUrl: "http://192.168.0.104:8000/api/merchant",
    shouldCollectCrashLog: true,
  );
  BuildConfig.instantiate(
    envType: Environment.DEVELOPMENT,
    envConfig: devConfig,
  );
  runApp(const MyApp());
}