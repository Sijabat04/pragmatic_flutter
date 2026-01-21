import 'package:flutter/material.dart';
import 'book.dart';
import 'book_details_page.dart';

class BookTile extends StatelessWidget {
  final BookModel bookModelObj;

  const BookTile({Key? key, required this.bookModelObj}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final info = bookModelObj.volumeInfo;

    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookDetailsPage(book: bookModelObj),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================= IMAGE =================
              SizedBox(
                width: 60,
                height: 90,
                child: (info?.imageLinks?.thumbnail != null)
                    ? Image.network(
                        info!.imageLinks!.thumbnail!
                            .replaceFirst('http://', 'https://'),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.book, size: 40);
                        },
                      )
                    : const Icon(Icons.book, size: 40),
              ),

              const SizedBox(width: 12),

              // ================= TEXT =================
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      info?.title ?? 'No Title',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      (info?.authors != null && info!.authors!.isNotEmpty)
                          ? info.authors!.join(', ')
                          : 'Unknown Author',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
