class BookModel {
  // Gunakan '?' karena data dari API eksternal tidak selalu menjamin ada
  final VolumeInfo? volumeInfo;
  final AccessInfo? accessInfo;
  final SaleInfo? saleInfo;

  BookModel({
    this.volumeInfo,
    this.accessInfo,
    this.saleInfo,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      volumeInfo: json['volumeInfo'] != null
          ? VolumeInfo.fromJson(json['volumeInfo'])
          : null,
      accessInfo: json['accessInfo'] != null
          ? AccessInfo.fromJson(json['accessInfo'])
          : null,
      saleInfo:
          json['saleInfo'] != null ? SaleInfo.fromJson(json['saleInfo']) : null,
    );
  }
}

class VolumeInfo {
  final String? title;
  final String? subtitle;
  final String? description;
  final List<dynamic>? authors;
  final String? publisher;
  final String? publishedDate;
  final ImageLinks? imageLinks;

  VolumeInfo({
    this.title,
    this.subtitle,
    this.description,
    this.authors,
    this.publisher,
    this.publishedDate,
    this.imageLinks,
  });

  factory VolumeInfo.fromJson(Map<String, dynamic> json) {
    return VolumeInfo(
      title: json['title'],
      subtitle: json['subtitle'],
      description: json['description'],
      authors: json['authors'] as List?,
      publisher: json['publisher'],
      publishedDate: json['publishedDate'],
      imageLinks: json['imageLinks'] != null
          ? ImageLinks.fromJson(json['imageLinks'])
          : null,
    );
  }
}

class ImageLinks {
  final String? smallThumbnail;
  final String? thumbnail;

  ImageLinks({this.smallThumbnail, this.thumbnail});

  factory ImageLinks.fromJson(Map<String, dynamic>? json) {
    return ImageLinks(
      // Menggunakan operator ?? agar jika null tetap mengembalikan String kosong
      smallThumbnail: json?['smallThumbnail'] ?? '',
      thumbnail: json?['thumbnail'] ?? '',
    );
  }
}

class AccessInfo {
  final String? webReaderLink;

  AccessInfo({this.webReaderLink});

  factory AccessInfo.fromJson(Map<String, dynamic> json) {
    return AccessInfo(webReaderLink: json['webReaderLink']);
  }
}

class SaleInfo {
  final String? saleability;
  final String? buyLink;

  SaleInfo({this.saleability, this.buyLink});

  factory SaleInfo.fromJson(Map<String, dynamic> json) {
    return SaleInfo(
      saleability: json['saleability'],
      buyLink: json['buyLink'],
    );
  }
}
