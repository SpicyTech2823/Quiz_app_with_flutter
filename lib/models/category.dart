
class Category {
  final String id;
  final String name;
  String? image; // Optional field for category image

  Category({
    required this.id,
    required this.name,
    this.image,
  });
}