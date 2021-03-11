import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_bookshelf/views/splash.dart';

class BookSearch extends StatefulWidget {
  static String id = SplashScreen.id + '/BookList';

  @override
  _BookSearchState createState() => _BookSearchState();
}

class _BookSearchState extends State<BookSearch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text("$widget"),
        ),
      ),
    );
  }
}
