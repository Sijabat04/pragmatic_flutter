import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart' as paths;

import '../theme_prefs.dart';

// Construct database for all platforms
MyDatabase constructDb({bool logStatements = false}) {
  if (Platform.isIOS || Platform.isAndroid) {
    final executor = LazyDatabase(() async {
      final dataDir = await paths.getApplicationDocumentsDirectory();
      final dbFile = File(p.join(dataDir.path, 'db.sqlite'));
      return NativeDatabase(
        dbFile,
        logStatements: logStatements,
      );
    });
    return MyDatabase(executor);
  }

  if (Platform.isMacOS || Platform.isLinux || Platform.isWindows) {
    final file = File('db.sqlite');
    return MyDatabase(
      NativeDatabase(
        file,
        logStatements: logStatements,
      ),
    );
  }

  // Web or fallback
  return MyDatabase(
    NativeDatabase.memory(
      logStatements: logStatements,
    ),
  );
}
