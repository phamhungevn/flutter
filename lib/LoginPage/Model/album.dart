class Album {
  final int id;
  final String name;

  const Album({
    required this.id,
    required this.name,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'],
      name: json['name'],
    );
  }
}