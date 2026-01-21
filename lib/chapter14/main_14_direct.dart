import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// 1. IMPORT FILE CONFIG
// Pastikan path ini benar. Jika config.dart ada di folder yang sama, gunakan 'config.dart'
import '../config.dart';
import 'book.dart';
import 'book_details_page.dart';
import 'booktile.dart';

void main() => runApp(const BooksApp());

class BooksApp extends StatelessWidget {
  const BooksApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const BooksListing(),
    );
  }
}

Future<List<BookModel>> makeHttpCall() async {
  // 2. GUNAKAN VARIABEL DARI CONFIG.DART
  // Kita langsung panggil YOUR_API_KEY karena di config.dart tidak dibungkus class
  const String apiKey = YOUR_API_KEY;

  final apiEndpoint =
      "https://www.googleapis.com/books/v1/volumes?key=$apiKey&q=python+coding";

  try {
    final http.Response response = await http
        .get(Uri.parse(apiEndpoint), headers: {'Accept': 'application/json'});

    // Debugging untuk mengecek koneksi di Terminal VS Code
    debugPrint("Status Code: ${response.statusCode}");

    if (response.statusCode == 200) {
      final jsonObject = json.decode(response.body);
      var list = jsonObject['items'] as List? ?? [];
      return list.map((e) => BookModel.fromJson(e)).toList();
    } else {
      debugPrint("API Error: ${response.body}");
      return [];
    }
  } catch (e) {
    debugPrint("Network Error: $e");
    return [];
  }
}

class BooksListing extends StatefulWidget {
  const BooksListing({super.key});

  @override
  _BooksListingState createState() => _BooksListingState();
}

class _BooksListingState extends State<BooksListing> {
  List<BookModel> booksListing = [];
  bool isLoading = true;

  void fetchBooks() async {
    var response = await makeHttpCall();
    if (mounted) {
      setState(() {
        booksListing = response;
        isLoading = false;
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
        title: const Text("Books Listing"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : booksListing.isEmpty
              ? const Center(
                  child: Text("No books found. Check Debug Console."))
              : ListView.builder(
                  itemCount: booksListing.length,
                  itemBuilder: (context, index) {
                    final currentBook = booksListing[index];
                    return GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              BookDetailsPage(book: currentBook),
                        ),
                      ),
                      child: BookTile(bookModelObj: currentBook),
                    );
                  },
                ),
    );
  }
}
