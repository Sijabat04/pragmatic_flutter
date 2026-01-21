import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../config.dart';
import 'booktile.dart';

void main() => runApp(const BooksApp());

class BooksApp extends StatelessWidget {
  const BooksApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
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
  List<dynamic> booksListing = [];
  bool isLoading = false;

  Future<void> fetchBooks() async {
    if (!mounted) return;

    setState(() => isLoading = true);

    final url = Uri.parse(
      'https://www.googleapis.com/books/v1/volumes?q=python+coding&key=$YOUR_API_KEY',
    );

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 10));

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          booksListing = data['items'] ?? [];
        });
      } else {
        setState(() => booksListing = []);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => booksListing = []);
    } finally {
      if (mounted) setState(() => isLoading = false);
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
      appBar: AppBar(title: const Text('Books Listing')),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchBooks,
        child: const Icon(Icons.refresh),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : booksListing.isEmpty
              ? const Center(child: Text('No Books Found'))
              : ListView.builder(
                  itemCount: booksListing.length,
                  itemBuilder: (context, index) {
                    return BookTile(book: booksListing[index]);
                  },
                ),
    );
  }
}
