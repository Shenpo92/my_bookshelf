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

  Future<bool> selectBook(Book book) async {
    _selectedBook = null;
    http.Response response;
    final url = Uri.parse(kBaseUrl + kBooks + '/${book.isbn13}');
    try {
      response = await http.get(url);
      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        if (body != null) {
          book.parseDetails(body);
        } else {
          /// API responded with code 200 but the body is empty
          return false;
        }
      } else {
        /// API responded with code != 200
        return false;
      }
    } catch (e) {
      ///HTTP caught error
      print('Error Caught: $e');
      return false;
    }
    _selectedBook = book;
    notifyListeners();
    return true;
  }

  void clearList() {
    _bookList = [];
    notifyListeners();
  }

  void addNote(String note) {
    _selectedBook.note = note;
    notifyListeners();
  }
}
