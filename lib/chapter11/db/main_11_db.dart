// Persisting selected theme using Database
import 'package:flutter/material.dart';

import '../themes.dart';
import 'plugins/shared.dart';
import 'theme_prefs.dart';

void main() => runApp(const BooksApp());

class BooksApp extends StatefulWidget {
  const BooksApp({super.key});

  @override
  State<BooksApp> createState() => _BooksAppState();
}

class _BooksAppState extends State<BooksApp> {
  AppThemes currentTheme = AppThemes.light;
  late MyDatabase _database;

  // ================== LOAD THEME FROM DB ==================
  Future<void> loadActiveTheme() async {
    try {
      final themeData = await _database.getActiveTheme();

      if (!mounted) return;

      setState(() {
        currentTheme = AppThemes.values[themeData.themeId];
      });
    } catch (e) {
      // Jika DB kosong / error → fallback
      setState(() {
        currentTheme = AppThemes.light;
      });
    }
  }

  // ================== SWITCH THEME ==================
  Future<void> switchTheme() async {
    final oldTheme = currentTheme;

    // Update UI dulu
    setState(() {
      currentTheme =
          currentTheme == AppThemes.light ? AppThemes.dark : AppThemes.light;
    });

    // Cek apakah theme lama ada di DB
    final bool exists = await _database.themeIdExists(oldTheme.index);

// Hapus theme lama jika ada
    if (exists) {
      await _database.deactivateTheme(oldTheme.index);
    }

// Simpan theme baru
    await _database.activateTheme(currentTheme);
  }

  @override
  void initState() {
    super.initState();

    // Init database
    _database = constructDb(logStatements: true);

    // Load theme dari database
    loadActiveTheme();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // ================== UI ==================
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: currentTheme == AppThemes.light ? defaultTheme : darkTheme,
      home: Scaffold(
        appBar: AppBar(
          leading: const Icon(Icons.home),
          title: const Text("Books Listing"),
          actions: [
            IconButton(
              icon: const Icon(Icons.brightness_6),
              onPressed: switchTheme,
            )
          ],
        ),
        body: const BooksListing(),
      ),
    );
  }
}

// ================== BOOK DATA ==================
List<Map<String, dynamic>> bookData() {
  return [
    {
      'title': 'Book Title',
      'authors': ['Author1', 'Author2'],
      'image': 'assets/book_cover.png',
    },
    {
      'title': 'Book Title 2',
      'authors': ['Author1'],
      'image': 'assets/book_cover.png',
    }
  ];
}

// ================== BOOK LISTING ==================
class BooksListing extends StatelessWidget {
  const BooksListing({super.key});

  @override
  Widget build(BuildContext context) {
    final booksListing = bookData();

    return ListView.builder(
      itemCount: booksListing.length,
      itemBuilder: (context, index) {
        final book = booksListing[index];

        return Card(
          elevation: 5,
          margin: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book['title'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Author(s): ${book['authors'].join(", ")}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Image.asset(
                  book['image'],
                  width: 60,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
