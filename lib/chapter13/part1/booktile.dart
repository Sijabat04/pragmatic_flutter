import 'package:flutter/material.dart';

class BookTile extends StatelessWidget {
  final dynamic book;

  const BookTile({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final volumeInfo = book['volumeInfo'] ?? {};
    final imageLinks = volumeInfo['imageLinks'];

    String? thumbnailUrl = imageLinks?['thumbnail'];
    if (thumbnailUrl != null) {
      thumbnailUrl = thumbnailUrl.replaceFirst('http:', 'https:');
    }

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== Gambar Buku =====
            Container(
              width: 60,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
              ),
              child: thumbnailUrl != null
                  ? Image.network(
                      thumbnailUrl,
                      fit: BoxFit.cover,
                      // PENTING untuk Flutter Web
                      webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.book);
                      },
                    )
                  : const Icon(Icons.book),
            ),

            const SizedBox(width: 15),

            // ===== Informasi Buku =====
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    volumeInfo['title'] ?? 'No Title',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    volumeInfo['authors'] != null
                        ? 'By: ${volumeInfo['authors'].join(", ")}'
                        : 'Unknown Author',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
