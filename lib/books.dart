class Book {
  String title;
  String subtitle;
  String isbn13;
  String price;
  String image;
  String url;

  Book(
      this.title, this.subtitle, this.isbn13, this.price, this.image, this.url);

  Book.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        subtitle = json['subtitle'],
        isbn13 = json['isbn13'],
        price = json['price'],
        image = json['image'],
        url = json['url'];

  static List<Book> parseList(List<dynamic> list) {
    return list.map((i) => Book.fromJson(i)).toList();
  }
}
