import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../book.dart';

class BookDetailColumn extends StatelessWidget {
  const BookDetailColumn({
    Key key,
    @required Book book,
  })  : _book = book,
        super(key: key);

  final Book _book;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BookDetailRow(
          title: "Title",
          text: _book.title,
        ),
        Divider(
          height: 10,
          thickness: 3,
        ),
        BookDetailRow(
          title: "Subtitle",
          text: _book.subtitle,
        ),
        Divider(
          height: 10,
          thickness: 3,
        ),
        BookDetailRow(
          title: "Authors",
          text: _book.authors,
        ),
        Divider(
          height: 10,
          thickness: 3,
        ),
        BookDetailRow(
          title: "Publisher",
          text: _book.publisher,
        ),
        Divider(
          height: 10,
          thickness: 3,
        ),
        BookDetailRow(
          title: "Pages",
          text: _book.pages,
        ),
        Divider(
          height: 10,
          thickness: 3,
        ),
        BookDetailRow(
          title: "Year",
          text: _book.year,
        ),
        Divider(
          height: 10,
          thickness: 3,
        ),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                'Rating',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: _getRating(),
            )
          ],
        ),
        Divider(
          height: 10,
          thickness: 3,
        ),
        BookDetailRow(
          title: "Desc",
          text: _book.desc,
        ),
        Divider(
          height: 10,
          thickness: 3,
        ),
        BookDetailRow(
          title: "Price",
          text: _book.price,
        ),
        Divider(
          height: 10,
          thickness: 3,
        ),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                'URL',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: GestureDetector(
                onTap: () => _launchURL(_book.url),
                child: Text(
                  _book.url,
                  style: TextStyle(fontSize: 14, color: Colors.blue),
                ),
              ),
            )
          ],
        ),
        Divider(
          height: 10,
          thickness: 3,
        ),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                'PDFs',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: _book.pdf == null ? Text('-') : _getPdf(),
            )
          ],
        ),
      ],
    );
  }

  void _launchURL(String url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';

  Column _getPdf() {
    List<Widget> list = [];
    for (var url in _book.pdf) {
      list.add(
        GestureDetector(
          onTap: () => _launchURL(url),
          child: Text(
            url,
            style: TextStyle(fontSize: 14, color: Colors.blue),
          ),
        ),
      );
    }
    return Column(children: list);
  }

  Row _getRating() {
    List<Widget> list = [];
    for (int i = 0; i < _book.rating; i++) {
      list.add(
        Icon(
          Icons.star,
          color: Colors.yellow,
        ),
      );
    }
    return Row(children: list);
  }
}

class BookDetailRow extends StatelessWidget {
  const BookDetailRow({
    Key key,
    @required String title,
    @required String text,
  })  : _text = text,
        _title = title,
        super(key: key);

  final String _title;
  final String _text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            '$_title:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Text(
            _text,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
