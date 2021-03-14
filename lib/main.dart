import 'package:flutter/material.dart';
import 'package:my_bookshelf/book_provider.dart';
import 'package:my_bookshelf/constants/constants.dart';
import 'package:my_bookshelf/views/book_detail.dart';
import 'package:my_bookshelf/views/book_search.dart';
import 'package:my_bookshelf/views/splash.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => BookProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Bookshelf',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
      ),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        BookSearch.id: (context) => BookSearch(),
        BookDetail.id: (context) => BookDetail(),
      },
    );
  }
}
