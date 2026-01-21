//importing the Dart package
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../config.dart';
import 'bookmodel.dart';
import 'booktile.dart';

void main() => runApp(BooksApp());

class BooksApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BooksListing(),
    );
  }
}

// Perbaikan pada Fungsi HTTP
Future<List<BookModel>> makeHttpCall() async {
  // Langsung gunakan variabel String dari config.dart
  final apiKey = YOUR_API_KEY;
  final apiEndpoint =
      "https://www.googleapis.com/books/v1/volumes?key=$apiKey&q=python+coding";

  try {
    final http.Response response = await http
        .get(Uri.parse(apiEndpoint), headers: {'Accept': 'application/json'});

    if (response.statusCode == 200) {
      final jsonObject = json.decode(response.body);

      // Cek apakah 'items' ada dalam response JSON
      if (jsonObject['items'] != null) {
        var list = jsonObject['items'] as List;
        return list.map((e) => BookModel.fromJson(e)).toList();
      } else {
        return []; // Kembalikan list kosong jika tidak ada buku ditemukan
      }
    } else {
      throw Exception("Gagal memuat data: ${response.statusCode}");
    }
  } catch (e) {
    print("Error: $e");
    return [];
  }
}

class BooksListing extends StatefulWidget {
  @override
  _BooksListingState createState() => _BooksListingState();
}

class _BooksListingState extends State<BooksListing> {
  // Perbaikan 1: Inisialisasi dengan List kosong untuk menghindari error Null Safety
  List<BookModel> booksListing = [];
  bool isLoading = true; // Tambahkan status loading

  fetchBooks() async {
    var response = await makeHttpCall();

    if (mounted) {
      setState(() {
        booksListing = response;
        isLoading = false; // Data selesai diambil
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
      // Perbaikan 2: Tampilkan loading indicator jika data belum siap
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : booksListing.isEmpty
              ? const Center(child: Text("Buku tidak ditemukan"))
              : ListView.builder(
                  itemCount: booksListing.length,
                  itemBuilder: (context, index) {
                    // Perbaikan 3: Pastikan parameter sesuai dengan BookTile terbaru
                    return BookTile(bookModelObj: booksListing[index]);
                  },
                ),
    );
  }
}
