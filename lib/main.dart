import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'app.dart';
import 'package:tailor/services/database_services.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService.instance.database;
  

  await windowManager.ensureInitialized();

  const windowOptions = WindowOptions(
    size: Size(350, 650),
    minimumSize: Size(350, 400),
    center: true,
    title: "Tailor",
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const MyApp());
}
