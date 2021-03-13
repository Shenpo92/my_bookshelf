import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_bookshelf/books.dart';
import 'package:my_bookshelf/constants/constants.dart';
import 'package:my_bookshelf/views/book_detail.dart';
import 'package:my_bookshelf/views/splash.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';

class BookSearch extends StatefulWidget {
  static String id = SplashScreen.id + '/BookSearch';

  @override
  _BookSearchState createState() => _BookSearchState();
}

class _BookSearchState extends State<BookSearch> {
  TextEditingController _search = TextEditingController();
  ScrollController _scrollController = ScrollController();
  List<Book> _bookList = [];
  int _totalBooks;
  int _page;
  bool _error;
  bool _noMoreData;
  bool _isLoading;

  @override
  void initState() {
    super.initState();
    _error = false;
    _noMoreData = false;
    _isLoading = false;
    _totalBooks = 0;
    _page = 1;
    _scrollController.addListener(() {
      final delta = 250.00;

      /// Check if we are close to the end of the list to load more books
      if ((_scrollController.position.maxScrollExtent -
              _scrollController.position.pixels) <=
          delta) {
        print('${_bookList.length}/$_totalBooks');

        /// Check if there are more books to fetch. It prevents from doing unnecessary calls to API
        if (_bookList.isNotEmpty && _bookList.length < _totalBooks) {
          fetch();
        } else {
          setState(() {
            _isLoading = false;
            _noMoreData = true;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _search.dispose();
  }

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
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _search,
                        onSubmitted: (__) async {
                          resetSearch();
                          await fetch();
                        },
                      ),
                    ),
                    GestureDetector(
                      child: Icon(
                        Icons.search,
                        size: 40,
                      ),
                      onTap: () async {
                        resetSearch();
                        await fetch();
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: getListBody(),
              ),
            ],
          ),
        ));
  }

  Widget getListBody() {
    if (_bookList.isEmpty && _isLoading == true) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (_error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: kPrimaryColor,
              size: 200,
            ),
            SizedBox(
              height: 20,
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text: 'Could not find any book for : ',
                  style: TextStyle(color: kSecondaryColor),
                  children: [
                    TextSpan(
                      text: _search.text,
                      style: TextStyle(color: kPrimaryColor),
                    ),
                    TextSpan(
                      text: "\nPlease try again...",
                      style: TextStyle(color: kSecondaryColor),
                    )
                  ]),
            ),
          ],
        ),
      );
    } else {
      return ListView.builder(
          controller: _scrollController,
          itemCount: _bookList.length,
          itemBuilder: (context, index) {
            if (index == _bookList.length - 1) {
              if (_noMoreData == true) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: Text('No more books to load ...'),
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            }
            return GestureDetector(
              onTap: _bookDetail,
              child: Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.network(
                      _bookList[index].image,
                      width: 100,
                      height: 100,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _bookList[index].title,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              _bookList[index].subtitle,
                              style: TextStyle(fontSize: 12),
                            ),
                            GestureDetector(
                              onTap: () => _launchURL(_bookList[index].url),
                              child: Text(
                                _bookList[index].url,
                                style:
                                    TextStyle(fontSize: 10, color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _bookList[index].price,
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
    }
  }

  void _bookDetail() {
    Navigator.pushNamed(context, BookDetail.id);
  }

  void _launchURL(String url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';

  Future<void> fetch() async {
    http.Response response;
    final url = Uri.parse(
        kBaseUrl + kSearch + _search.text + ((_page != 1) ? '/$_page' : ''));

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
            setState(() {
              _page++;
              _isLoading = false;
            });
          } else {
            setState(() {
              _isLoading = false;
              _error = true;
            });
          }
        } else {
          setState(() {
            _error = true;
            _isLoading = false;
          });
        }
      } catch (e) {
        print('Error Caught: $e');
        setState(() {
          _error = true;
          _isLoading = false;
        });
      }
    }
  }

  void resetSearch() {
    setState(() {
      _totalBooks = 0;
      _bookList = [];
      _page = 1;
      _error = false;
      _noMoreData = false;
    });
  }
}
