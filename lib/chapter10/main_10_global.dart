//Building BooksApp App's User Interface.
//Global theme demonstration
import 'package:flutter/material.dart';

/// Chapter10: Flutter Themes
//void main() => runApp(BooksApp());

ThemeData defaultTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.blue,
  colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
      .copyWith(secondary: Colors.lightBlueAccent),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.blue,
    iconTheme: IconThemeData(color: Colors.white),
  ),
);

ThemeData pinkTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.pink,
  colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.pink)
      .copyWith(secondary: Colors.pinkAccent),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.orange,
  colorScheme: ColorScheme.fromSwatch(brightness: Brightness.dark)
      .copyWith(secondary: Colors.yellowAccent),
);

//Showing book listing in ListView
class BooksApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      //NEW CODE: theme property
      theme: defaultTheme,
      home: Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.home),
          title: Text("Books Listing"),
        ),
        body: BooksListing(),
      ),
    );
  }
}

List bookData() {
  return [
    {
      'title': 'Book Title',
      'authors': ['Author1', 'Author2'],
      'image': 'assets/book_cover.png'
    },
    {
      'title': 'Book Title 2',
      'authors': ['Author1'],
      'image': 'assets/book_cover.png'
    }
  ];
}

class BooksListing extends StatelessWidget {
  final booksListing = bookData();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: booksListing.length, // ✔ fixed unnecessary null check
      itemBuilder: (context, index) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 5,
          margin: EdgeInsets.all(10),
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
                        '${booksListing[index]['title']}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      booksListing[index]['authors'] != null
                          ? Text(
                              'Author(s): ${booksListing[index]['authors'].join(", ")}',
                              style: TextStyle(fontSize: 14),
                            )
                          : Text(""),
                    ],
                  ),
                ),
                booksListing[index]['image'] != null
                    ? Image.asset(
                        booksListing[index]['image'],
                        fit: BoxFit.fill,
                      )
                    : Container(),
              ],
            ),
          ),
        );
      },
    );
  }
}
