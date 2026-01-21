import 'package:flutter/material.dart';
import 'book.dart';

class BookDetailsPage extends StatelessWidget {
  final BookModel book;
  const BookDetailsPage({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mempermudah akses data volumeInfo
    final volumeInfo = book.volumeInfo;

    return Scaffold(
      appBar: AppBar(
        title: Text(volumeInfo?.title ?? "No Title"),
      ),
      // Menggunakan SingleChildScrollView agar teks panjang bisa di-scroll
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            // PERBAIKAN: Gunakan ?. dan ?? untuk menangani String?
            volumeInfo?.description ??
                "No description available for this book.",
            textAlign: TextAlign.justify,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
