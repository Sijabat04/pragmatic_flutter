class Book {
  final String id;
  final String title;
  final List<String> authors;
  final String thumbnail;
  final String description;
  final String previewLink;

  Book({
    required this.id,
    required this.title,
    required this.authors,
    required this.thumbnail,
    required this.description,
    required this.previewLink,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    final info = json['volumeInfo'];

    return Book(
      id: json['id'] ?? '',
      title: info['title'] ?? 'No Title',
      authors: info['authors'] != null
          ? List<String>.from(info['authors'])
          : ['Unknown'],
      thumbnail: info['imageLinks']?['thumbnail']
              ?.replaceAll('http://', 'https://') ??
          '',
      description: info['description'] ?? 'No description available.',
      previewLink: info['previewLink'] ?? '',
    );
  }
}

