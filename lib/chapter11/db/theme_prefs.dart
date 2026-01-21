import 'package:drift/drift.dart';
import '../themes.dart';

part 'theme_prefs.g.dart';

class ThemePrefs extends Table {
  IntColumn get themeId => integer()();
  TextColumn get themeName => text()();
}

@DriftDatabase(tables: [ThemePrefs])
class MyDatabase extends _$MyDatabase {
  MyDatabase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          await m.deleteTable(themePrefs.actualTableName);
          await m.createAll();
        },
        beforeOpen: (details) async {
          if (details.wasCreated) {
            await into(themePrefs).insert(
              ThemePrefsCompanion.insert(
                themeId: 0,
                themeName: AppThemes.light.toString(),
              ),
            );
          }
        },
      );

  // ================= FIXED METHODS =================

  /// SIMPAN THEME
  Future<void> activateTheme(AppThemes theme) async {
    await into(themePrefs).insert(
      ThemePrefsCompanion.insert(
        themeId: theme.index,
        themeName: theme.toString(),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  /// HAPUS THEME
  Future<void> deactivateTheme(int id) async {
    await (delete(themePrefs)
          ..where((tbl) => tbl.themeId.equals(id)))
        .go();
  }

  /// CEK THEME ADA ATAU TIDAK
  Future<bool> themeIdExists(int id) async {
    final result = await (select(themePrefs)
          ..where((tbl) => tbl.themeId.equals(id)))
        .get();

    return result.isNotEmpty;
  }

  /// AMBIL THEME AKTIF
  Future<ThemePref> getActiveTheme() {
    return select(themePrefs).getSingle();
  }
}
