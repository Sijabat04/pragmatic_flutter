// Building BooksApp App's User Interface.
// Populating list from Demo data
// Importing the Flutter package
import 'package:flutter/material.dart';

void main() {
  runApp(BooksApp());
}

/// Chapter 09: Building User Interface for BooksApp
///
/// Uncomment the line below to run this file directly:
// void main() => runApp(BooksApp());

class BooksApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Books Listing"),
        ),
        body: const BooksListing(),
      ),
    );
  }
}

/// Demo Data
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

class BooksListing extends StatelessWidget {
  const BooksListing({super.key});

  @override
  Widget build(BuildContext context) {
    final booksListing = bookData();

    return ListView.builder(
      itemCount: booksListing.length,
      itemBuilder: (context, index) {
        final book = booksListing[index];
        final title = book['title'] ?? 'No Title';
        final authors = (book['authors'] as List?)?.join(", ") ?? 'Unknown';
        final image = book['image'] as String?;

        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 5,
          margin: const EdgeInsets.all(10),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// Text Section
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Author(s): $authors',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),

                /// Image Section
                if (image != null)
                  Image.asset(
                    image,
                    width: 60,
                    height: 80,
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
