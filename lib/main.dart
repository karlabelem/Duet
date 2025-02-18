import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    // In development, you might want to see the logs in the console
    // In production, you might want to send them to a logging service
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
  });

  runApp(MyApp());
}
