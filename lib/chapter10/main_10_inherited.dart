/// Switching Themes using InheritedWidget
import 'package:flutter/material.dart';

import 'booklisting.dart';

class BooksApp extends StatelessWidget {
  const BooksApp({super.key}); // Tambah const + super.key

  @override
  Widget build(BuildContext context) {
    return RootWidget(
      child: BooksAppScreen(
        child: BooksListing(),
      ),
    );
  }
}

class RootWidget extends StatefulWidget {
  final Widget child;

  const RootWidget({
    required this.child,
    super.key, // Null-safety version
  });

  static RootWidgetState of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<MyInheritedWidget>()!
        .data;
  }

  @override
  State<StatefulWidget> createState() => RootWidgetState();
}

class RootWidgetState extends State<RootWidget> {
  MyThemes _currentTheme = MyThemes.light;
  MyThemes get currentTheme => _currentTheme;

  void switchTheme() {
    setState(() {
      _currentTheme =
          _currentTheme == MyThemes.light ? MyThemes.dark : MyThemes.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MyInheritedWidget(
      child: widget.child,
      data: this,
    );
  }
}

class MyInheritedWidget extends InheritedWidget {
  final RootWidgetState data;

  const MyInheritedWidget({
    required Widget child,
    required this.data,
    super.key,
  }) : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}

class BooksAppScreen extends StatelessWidget {
  final Widget child;

  const BooksAppScreen({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: RootWidget.of(context).currentTheme == MyThemes.light
          ? themeData[0]
          : themeData[1],
      home: Scaffold(
        appBar: AppBar(
          leading: const Icon(Icons.home),
          title: const Text("Books Listing"),
          actions: [
            IconButton(
              icon: const Icon(Icons.all_inclusive),
              onPressed: () => RootWidget.of(context).switchTheme(),
            )
          ],
        ),
        body: child,
      ),
    );
  }
}

enum MyThemes { light, dark }

final List<ThemeData> themeData = [
  ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    secondaryHeaderColor: Colors.lightBlueAccent, // accentColor deprecated
  ),
  ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.orange,
    secondaryHeaderColor: Colors.yellowAccent,
  )
];
