import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_bookshelf/views/splash.dart';

class BookDetail extends StatefulWidget {
  static String id = SplashScreen.id + '/BookDetail';

  @override
  _BookDetailState createState() => _BookDetailState();
}

class _BookDetailState extends State<BookDetail> {
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
