// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Search {
  final String id;
  final String title;
  Search({
    required this.id,
    required this.title,
  });

  Search copyWith({
    String? id,
    String? title,
  }) {
    return Search(
      id: id ?? this.id,
      title: title ?? this.title,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
    };
  }

  factory Search.fromMap(Map<String, dynamic> map) {
    return Search(
      id: map['id'] ?? "",
      title: map['title'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory Search.fromJson(String source) =>
      Search.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Search(id: $id, title: $title)';

  @override
  bool operator ==(covariant Search other) {
    if (identical(this, other)) return true;

    return other.id == id && other.title == title;
  }

  @override
  int get hashCode => id.hashCode ^ title.hashCode;
}
