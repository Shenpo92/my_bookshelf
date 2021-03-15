import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:my_bookshelf/book.dart';
import 'package:http/http.dart' as http;
import 'package:my_bookshelf/constants/constants.dart';

class BookProvider with ChangeNotifier {
  List<Book> _bookList = [];
  Book _selectedBook;
  List<Book> get bookList => _bookList;
  bool _isLoading = false;
  int _totalBooks = 0;
  int _page = 1;

  void addToList(List<Book> books) {
    _bookList.addAll(books);
    notifyListeners();
  }

  Book get selectedBook => _selectedBook;
  bool get isLoading => _isLoading;
  int get totalBooks => _totalBooks;

  Future<bool> fetchBookList(String search) async {
    http.Response response;
    final url = Uri.parse(
        kBaseUrl + kSearch + search + ((_page != 1) ? '/$_page' : ''));

    /// Makes sure that we are not already processing an API call before re-calling it.
    if (_isLoading == false) {
      _isLoading = true;
      try {
        response = await http.get(url);
        if (response.statusCode == 200) {
          final body = json.decode(response.body);
          if (body != null && int.parse(body['total']) != 0) {
            _totalBooks = int.parse(body['total']);
            _bookList.addAll(Book.parseList(body['books']));
            _page++;
            _isLoading = false;
          } else {
            /// API responded with code 200 but the body is empty
            _isLoading = false;
            return false;
          }
        } else {
          /// API responded with code != 200
          _isLoading = false;
          return false;
        }
      } catch (e) {
        ///HTTP caught error
        print('Error Caught: $e');
        _isLoading = false;
        return false;
      }
    }
    notifyListeners();
    return true;
  }

  Future<bool> fetchBookDetail(Book book) async {
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

  void clearSelectedBook() {
    _selectedBook = null;
    notifyListeners();
  }

  /// This function allows to clear the list of books before any search to prevent data from previous search to also appear in the results.
  void clearList() {
    _bookList = [];
    _page = 1;
    notifyListeners();
  }

  void addNote(String note) {
    _selectedBook.note = note;
    notifyListeners();
  }
}
