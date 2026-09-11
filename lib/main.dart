import 'package:flutter/widgets.dart';

import 'package:flood/app.dart';
import 'package:flood/core/window/window_bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeWindowPersistence();
  runApp(const FloodApp());
}
