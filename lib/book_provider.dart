import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:my_bookshelf/book.dart';
import 'package:http/http.dart' as http;
import 'package:my_bookshelf/constants/constants.dart';

class BookProvider with ChangeNotifier {
  List<Book> _bookList = [];
  Book _selectedBook;

  List<Book> get bookList => _bookList;

  void addToList(List<Book> books) {
    _bookList.addAll(books);
    notifyListeners();
  }

  Book get selectedBook => _selectedBook;

  void selectBook(Book book) async {
    _selectedBook = null;
    http.Response response;
    final url = Uri.parse(kBaseUrl + kBooks + '/${book.isbn13}');
    try {
      response = await http.get(url);
      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        if (body != null) {
          book.parseDetails(body);
          // setState(() {
          //   _page++;
          //   _isLoading = false;
          // });
        } else {
          /// API responded with code 200 but the body is empty
          // setState(() {
          //   _isLoading = false;
          //   _error = true;
          // });
        }
      } else {
        /// API responded with code != 200
        // setState(() {
        //   _error = true;
        //   _isLoading = false;
        // });
      }
    } catch (e) {
      ///HTTP caught error
      print('Error Caught: $e');
      // setState(() {
      //   _error = true;
      //   _isLoading = false;
      // });
    }
    _selectedBook = book;
    notifyListeners();
  }

  void addNote(String note) {
    _selectedBook.note = note;
    notifyListeners();
  }
}
