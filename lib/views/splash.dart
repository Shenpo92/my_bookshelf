import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_bookshelf/constants/constants.dart';
import 'package:my_bookshelf/views/book_search.dart';

class SplashScreen extends StatefulWidget {
  static String id = '/SplashScreen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Delaying navigation to first screen "Search"
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, BookSearch.id);
    });
  }

  route() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Image.asset("assets/logo.png"),
            ),
            CircularProgressIndicator(
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
            )
          ],
        ),
      ),
    );
  }
}
