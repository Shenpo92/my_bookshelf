import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_bookshelf/book.dart';
import 'package:my_bookshelf/book_provider.dart';
import 'package:my_bookshelf/constants/constants.dart';
import 'package:my_bookshelf/views/book_detail.dart';
import 'package:my_bookshelf/views/splash.dart';
import 'package:provider/provider.dart';
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
  BookProvider _bookProvider;
  bool _error;
  bool _noMoreData;
  bool _isLoading;
  bool _detailClicked;

  @override
  void initState() {
    super.initState();
    _error = false;
    _noMoreData = false;
    _isLoading = false;
    _detailClicked = false;
    _scrollController.addListener(() {
      final delta = 250.00;

      /// Check if we are close to the end of the list to load more books
      if ((_scrollController.position.maxScrollExtent -
              _scrollController.position.pixels) <=
          delta) {
        /// Check if there are more books to fetch. It prevents from doing unnecessary calls to API
        if (_bookList.isNotEmpty &&
            _bookList.length < _bookProvider.totalBooks) {
          fetch();
        } else {
          setState(() {
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
    _bookProvider = Provider.of<BookProvider>(context);
    _bookList = _bookProvider.bookList;
    _isLoading = _bookProvider.isLoading;

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
          actions: [
            _detailClicked
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                        child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                    )),
                  )
                : Container()
          ],
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
                        decoration:
                            InputDecoration(hintText: 'ex: Android, IOS ...'),
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
    if (_bookList.isEmpty) {
      if (_isLoading == true) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 200,
              color: Colors.grey[300],
            ),
            Text(
              "Nothing to show yet",
              style: TextStyle(color: Colors.grey[300], fontSize: 30),
            )
          ],
        );
      }
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
              onTap: () async {
                if (_detailClicked == false) {
                  setState(() => _detailClicked = true);
                  await _bookDetail(_bookList[index]);
                  setState(() => _detailClicked = false);
                }
              },
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
                            SizedBox(
                              height: 5,
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

  Future<void> fetch() async {
    if (!await _bookProvider.fetchBookList(_search.text)) {
      setState(() {
        _error = true;
      });
    }
  }

  Future<void> _bookDetail(Book book) async {
    if (_bookProvider.selectedBook == null) {
      if (!await _bookProvider.fetchBookDetail(book)) {
        final snackBar = SnackBar(
          content: Text(
            'Could not load information for this book',
            style: TextStyle(fontSize: 16),
          ),
          backgroundColor: Colors.redAccent,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        Navigator.pushNamed(context, BookDetail.id);
      }
    }
  }

  void _launchURL(String url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';

  void resetSearch() {
    _bookProvider.clearList();
    setState(() {
      _bookList = [];
      _error = false;
      _noMoreData = false;
    });
  }
}
