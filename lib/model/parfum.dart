class ParfumFields {
  static const List<String> values = [
    id,
    article,
    urlImage,
    title,
    type,
    price,
    url
  ];

  static const id = 'id';
  static const article = 'article';
  static const urlImage = 'url_image';
  static const title = 'title';
  static const type = 'type';
  static const price = 'price';
  static const url = 'url';
}

enum ParfumTypes {
  unisex,
  man,
  woman
}

extension ParfumTypesStringExtension on ParfumTypes {
  String get name {
    switch (this) {
      case ParfumTypes.unisex:
        return 'Унисекс';
      case ParfumTypes.man:
        return 'Мужские';
      case ParfumTypes.woman:
        return 'Женские';
      default:
        return '';
    }
  }
}

class Parfum {
  final int? id;
  final String article;
  final String urlImage;
  final String title;
  final String type;
  final double price;
  final String url;

  const Parfum(
      {this.id,
      required this.article,
      required this.urlImage,
      required this.title,
      required this.type,
      required this.price,
      required this.url});


  Map<String, Object?> toJson() {
    return {
      ParfumFields.id: id,
      ParfumFields.article: article,
      ParfumFields.urlImage: urlImage,
      ParfumFields.title: title,
      ParfumFields.type: type,
      ParfumFields.price: price,
      ParfumFields.url: url
    };
  }

  Parfum copy({
    int? id,
    String? article,
    String? urlImage,
    String? title,
    String? type,
    double? price,
    String? url,
  }) {
    return Parfum(
        id: id ?? this.id,
        article: article ?? this.article,
        urlImage: urlImage ?? this.urlImage,
        title: title ?? this.title,
        type: type ?? this.type,
        price: price ?? this.price,
        url: url ?? this.url);
  }

  static Parfum fromJson(Map<String, Object?> mMap) {
    return Parfum(
      id: mMap[ParfumFields.id] as int?,
      article: mMap[ParfumFields.article] as String,
      urlImage: mMap[ParfumFields.urlImage] as String,
      title: mMap[ParfumFields.title] as String,
      type: mMap[ParfumFields.type] as String,
      price: mMap[ParfumFields.price] as double,
      url: mMap[ParfumFields.url] as String,
    );
  }
}
