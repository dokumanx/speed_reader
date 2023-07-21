import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:speed_reader/app/app.dart';
import 'package:speed_reader/bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDocDir = await getApplicationDocumentsDirectory();
  final appDocPath = Directory('${appDocDir.path}/app_settings_storage');

  HydratedBloc.storage =
      await HydratedStorage.build(storageDirectory: appDocPath);
  await bootstrap(() => const App());
}
