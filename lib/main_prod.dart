import 'package:flutter/material.dart';
import 'package:flutter_infinite_list/di/config_inject.dart';
import 'package:flutter_infinite_list/flavors/build_config.dart';
import 'package:flutter_infinite_list/flavors/env_config.dart';
import 'package:flutter_infinite_list/flavors/environment.dart';
import 'package:flutter_infinite_list/main.dart';

void main() async{
  EnvConfig devConfig = EnvConfig(
    appName: "Infinite List with bloc",
    baseUrl: "https://jsonplaceholder.typicode.com",
    shouldCollectCrashLog: true,
  );
  BuildConfig.instantiate(
    envType: Environment.PRODUCTION,
    envConfig: devConfig,
  );
  configureDependencies();
  runApp(const MyApp());
}