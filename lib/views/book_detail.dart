import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_bookshelf/book_provider.dart';
import 'package:my_bookshelf/components/book_detail_column.dart';
import 'package:my_bookshelf/views/splash.dart';
import 'package:provider/provider.dart';
import '../book.dart';

class BookDetail extends StatefulWidget {
  static String id = SplashScreen.id + '/BookDetail';

  @override
  _BookDetailState createState() => _BookDetailState();
}

class _BookDetailState extends State<BookDetail> {
  BookProvider _bookProvider;
  Book _book;
  TextEditingController _notes;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _notes = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _notes.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _bookProvider = Provider.of<BookProvider>(context);
    _book = _bookProvider.selectedBook;
    if (_book != null && _book.note != null) {
      _notes.text = _book.note;
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 30,
            color: Colors.white,
          ),
          onPressed: () {
            _bookProvider.addNote(_notes.text);
            Navigator.pop(context);
          },
        ),
        title: Text("Book details"),
        centerTitle: false,
      ),
      body: _book == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Image.network(
                    _book.image,
                    width: 350,
                    height: 400,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: BookDetailColumn(
                      book: _book,
                    ),
                  ),
                  Divider(
                    height: 10,
                    thickness: 3,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Notes:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      decoration:
                          InputDecoration(hintText: 'Write a note ....'),
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      controller: _notes,
                      maxLines: 20,
                      onSubmitted: (_) {
                        _bookProvider.addNote(_notes.text);
                      },
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
