import 'package:flutter/material.dart';
import 'bookmodel.dart';

class BookTile extends StatelessWidget {
  final BookModel bookModelObj;

  // 1. Tambahkan '?' pada Key agar boleh null
  // 2. Tambahkan 'required' pada bookModelObj agar data wajib ada
  const BookTile({Key? key, required this.bookModelObj}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 3. Gunakan variabel lokal agar kode lebih pendek dan aman
    final volumeInfo = bookModelObj.volumeInfo;
    final imageLinks = volumeInfo?.imageLinks;

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
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    // 4. Gunakan ?. dan ?? untuk menghindari error jika title null
                    '${volumeInfo?.title ?? "No Title"}',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  // Menampilkan penulis jika tersedia
                  volumeInfo?.authors != null
                      ? Text(
                          'Author(s): ${volumeInfo!.authors!.join(", ")}',
                          style: const TextStyle(fontSize: 14),
                        )
                      : const Text("Author(s): Unknown"),
                ],
              ),
            ),
            // 5. Penanganan Gambar yang aman dari null
            (imageLinks?.thumbnail != null && imageLinks!.thumbnail!.isNotEmpty)
                ? Image.network(
                    imageLinks.thumbnail!,
                    width: 70,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image, size: 70),
                  )
                : const SizedBox(
                    width: 70,
                    child: Icon(Icons.book, size: 50, color: Colors.grey),
                  ),
          ],
        ),
      ),
    );
  }
}
