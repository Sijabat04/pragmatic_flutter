import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'book.dart';
import 'book_tile.dart';
import 'book_details_page.dart'; // INI HARUS ADA & PERSIS

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const BookListPage(),
    );
  }
}

class BookListPage extends StatefulWidget {
  const BookListPage({super.key});

  @override
  State<BookListPage> createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  List<Book> books = [];

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    final url = Uri.parse(
        "https://www.googleapis.com/books/v1/volumes?q=flutter");
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      final items = data['items'] as List;
      setState(() {
        books = items.map((e) => Book.fromJson(e)).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Book List")),
      body: ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, i) {
          return BookTile(
            book: books[i],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BookDetailsPage(book: books[i]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
