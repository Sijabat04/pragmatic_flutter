import '../config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(const BooksApp());

class Book {
  final String title;
  final String authors;
  final String thumbnailUrl;
  final String description;

  Book({
    required this.title,
    required this.authors,
    required this.thumbnailUrl,
    required this.description,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    final info = json['volumeInfo'] ?? {};
    final images = info['imageLinks'] ?? {};

    return Book(
      title: info['title'] ?? 'No Title',
      authors: (info['authors'] as List?)?.join(', ') ?? 'Unknown Author',
      // Mengubah http ke https secara paksa untuk keamanan browser
      thumbnailUrl: (images['thumbnail'] ?? '')
          .toString()
          .replaceFirst('http:', 'https:'),
      description: info['description'] ?? 'No description available.',
    );
  }
}

class BooksApp extends StatelessWidget {
  const BooksApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const BooksListing(),
    );
  }
}

class BooksListing extends StatefulWidget {
  const BooksListing({Key? key}) : super(key: key);

  @override
  State<BooksListing> createState() => _BooksListingState();
}

class _BooksListingState extends State<BooksListing> {
  List<Book> _books = [];
  bool _isLoading = true;
  String _errorMessage = '';

  Future<void> fetchBooks() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    // Menggunakan Uri.https agar lebih aman dan terstruktur
    final url = Uri.https('www.googleapis.com', '/books/v1/volumes', {
      'q': 'python coding',
      'key': YOUR_API_KEY,
    });

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['items'] != null) {
          setState(() {
            _books = (data['items'] as List)
                .map((item) => Book.fromJson(item))
                .toList();
            _isLoading = false;
          });
        } else {
          setState(() {
            _errorMessage = "Tidak ada buku yang ditemukan.";
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _errorMessage = "Gagal memuat data (Status: ${response.statusCode})";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage =
            "Koneksi gagal. Pastikan API Key benar dan ekstensi CORS aktif.\nError: $e";
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Katalog Buku Python"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchBooks,
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Text(_errorMessage,
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(color: Colors.red, fontSize: 16)),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _books.length,
                  itemBuilder: (context, index) {
                    final book = _books[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 12),
                      clipBehavior: Clip.antiAlias,
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Gambar dengan Placeholder & Error Handler
                            SizedBox(
                              width: 100,
                              child: book.thumbnailUrl.isNotEmpty
                                  ? Image.network(
                                      book.thumbnailUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(Icons.broken_image,
                                                  size: 40),
                                    )
                                  : const Icon(Icons.book, size: 40),
                            ),
                            // Informasi Teks
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      book.title,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      book.authors,
                                      style: TextStyle(color: Colors.grey[600]),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      book.description,
                                      style: const TextStyle(fontSize: 12),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
