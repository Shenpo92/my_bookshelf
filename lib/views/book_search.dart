import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_bookshelf/views/splash.dart';

class BookSearch extends StatefulWidget {
  static String id = SplashScreen.id + '/BookSearch';

  @override
  _BookSearchState createState() => _BookSearchState();
}

class _BookSearchState extends State<BookSearch> {
  TextEditingController search = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Tab(
            icon: Image.asset(
              "assets/icon.png",
              width: 40,
              height: 40,
            ),
          ),
          title: Text("Search a topic"),
          centerTitle: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: search,
                    ),
                  ),
                  Icon(
                    Icons.search,
                    size: 40,
                  ),
                ],
              ),
              //TODO: Create function to get the data from the API, Serialize the Json, returns the list and feeds it to the ListView. Maybe use streams and sink..
              Expanded(child: ListView())
            ],
          ),
        ));
  }
}
