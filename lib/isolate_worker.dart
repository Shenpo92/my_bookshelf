import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'package:http/http.dart' as http;
import 'package:my_bookshelf/constants/constants.dart';

class IsolateWorker {
  SendPort _sendPort;

  Isolate _isolate;

  Completer<List<dynamic>> _books;

  final _isolateReady = Completer<void>();

  IsolateWorker() {
    init();
  }

  Future<void> get isReady => _isolateReady.future;

  void dispose() {
    _isolate.kill();
  }

  Future<void> init() async {
    final receivePort = ReceivePort();
    final errorPort = ReceivePort();
    errorPort.listen(print);

    receivePort.listen(_handleMessage);
    _isolate = await Isolate.spawn(
      _isolateEntry,
      receivePort.sendPort,
      onError: errorPort.sendPort,
    );
  }

  Future<List<dynamic>> fetch(String search) async {
    var url = kBaseUrl + search;

    _sendPort.send(url);

    _books = Completer<List<dynamic>>();
    return _books.future;
  }

  void _handleMessage(dynamic message) {
    if (message is SendPort) {
      _sendPort = message;
      _isolateReady.complete();
      return;
    }

    if (message is List<dynamic>) {
      _books?.complete(message);
      _books = null;
      return;
    }

    throw UnimplementedError("Undefined behavior for message: $message");
  }

  static Future<List<dynamic>> _getBooks(String url) async {
    http.Response response;
    try {
      response = await http.get(Uri(path: url));
    } on SocketException catch (e) {
      // throw HackerNewsApiException(message: "$url couldn't be fetched: $e");
    }
    if (response.statusCode != 200) {
      // throw HackerNewsApiException(message: "$url returned non-HTTP200");
    }
    print(response.body);
    //
    // var result = parseStoryIds(response.body);
    //
    // return result.take(10).toList();
  }

  static void _isolateEntry(dynamic message) {
    SendPort sendPort;
    final receivePort = ReceivePort();

    receivePort.listen((dynamic url) async {
      assert(url is String);
      try {
        final books = await _getBooks(url);
        sendPort.send(books);
      } catch (e) {
        print(e);
      }

      // } finally {
      //   client.close();
      // }
    });

    if (message is SendPort) {
      sendPort = message;
      sendPort.send(receivePort.sendPort);
      return;
    }
  }
}

class Book {
  Book();
}
