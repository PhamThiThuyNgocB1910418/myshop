
class Product {
  final String? id;
  final String title;
  final String description;
  final double price;
  final String imageURL;
  final bool isFavorite;

  Product({
    this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageURL,
    this.isFavorite = false,
  });

  Product copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    String? imageURL,
    bool? isFavorite,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      imageURL: imageURL ?? this.imageURL,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

